# frozen_string_literal: true

require 'parser/current'

# This class could be used to dynamically generate documentation from cops spec.
# It recognizes bad and good examples by signal words like `raises`. Additional
# information for documentation could be passed by setting `DETAILS` constant.
class SpecsProcessor < Parser::AST::Processor
  attr_reader :cases

  LINE_BEGIN_OPEN_SQUARE_BRACKET = /\A\[/.freeze  # "/[/1, 2, 3]\n"
  CLOSE_SQUARE_BRACKET_END_LINE = /\]\z/.freeze   # "[1, 2, 3/]\n/"
  LINE_BEGIN_QUOTE = /\A[\'|\"]/.freeze           # "/'/idddqd',"
  QUOTE_COMMA_END_LINE = /[\'|\"]\,?\z/.freeze    # "'iddqd/',/"

  def initialize(*)
    super
    @cases = []
    @nesting = []
  end

  def process(node)
    @nesting.push(node)
    super
    @nesting.pop
  end

  def on_send(node)
    _, name, _body = *node
    cases << [current_it, source_code(node)] if name == :inspect_source
    super
  end

  private

  def source_code(node)
    prepare_code(node).tap do |code|
      code.shift if code.first.to_s.empty?
      code.pop if code.last.to_s.empty?
    end
  end

  def prepare_code(node)
    remove_array_wrapping(node.to_a.last.loc.expression.source)
      .split("\n")
      .map { |line| remove_string_wrapping(line) }
  end

  def current_it
    it_block = @nesting.reverse.find { |node| node.type == :block }
    it = it_block.to_a.first
    _, _, message_node = *it
    message_node.to_a.first
  end

  def remove_array_wrapping(source)
    source.sub(LINE_BEGIN_OPEN_SQUARE_BRACKET, '')
          .sub(CLOSE_SQUARE_BRACKET_END_LINE, '')
  end

  def remove_string_wrapping(line)
    line.strip.sub(LINE_BEGIN_QUOTE, '')
        .sub(QUOTE_COMMA_END_LINE, '')
  end
end

class Documentation
  SIGNAL_WORD = 'raises'
  PREFER_WORD = 'better'
  RULE_WORD = '[rule]'

  def cop_rules
    cops.map do |file|
      rules = spec_cases_for(file).select do |desc, _code|
        desc.include?(RULE_WORD)
      end
      [file, rules]
    end
  end

  def call
    cops.map do |file|
      present_cop(klass_const_for(file), spec_cases_for(file))
    end.flatten.join("\n")
  end

  private

  def cops
    Dir[File.join(File.dirname(__FILE__), 'cops', '*.rb')].sort
  end

  def present_cop(klass, specs)
    [
      "## #{klass}\n",                                  # header
      message(klass) + "\n"                             # description
    ] +
      specs.map do |(it, code)|
        [
          prepare(it).to_s, # case description
          "\n```ruby\n#{mention(it)}\n#{code.join("\n")}\n```\n" # code example
        ]
      end
  end

  def prepare(it_description)
    it_description.sub("#{RULE_WORD} ", '')
  end

  def mention(it_description)
    it_description.include?(SIGNAL_WORD) ? '# bad' : '# good'
  end

  def message(klass)
    [
      klass.const_get(:OFFENSE),
      *(klass.const_get(:DETAILS) if klass.const_defined?(:DETAILS))
    ].join("\n")
  end

  def spec_cases_for(file)
    source_code = File.read(
      file.sub('/lib/', '/spec/')
          .sub(/.rb$/, '_spec.rb')
    )
    SpecsProcessor.new.tap do |processor|
      processor.process(Parser::CurrentRuby.parse(source_code))
    end.cases.select(&method(:allowed?))
  end

  def allowed?(example)
    desc, _code = example
    desc.include?(RULE_WORD)
  end

  def klass_const_for(file)
    require file
    Ducalis.const_get(camelize(File.basename(file).sub(/.rb$/, '')))
  end

  def camelize(snake_case_word)
    snake_case_word.sub(/^[a-z\d]*/, &:capitalize).tap do |string|
      string.gsub!(%r{(?:_|(/))([a-z\d]*)}i) do
        "#{Regexp.last_match(1)}#{Regexp.last_match(2).capitalize}"
      end
      string.gsub!('/', '::')
    end
  end
end
