require 'net/http'
require 'json'

class OchoKit
  API_PATH      = 'https://api.github.com'.freeze
  REVIEWS_PATH  = "#{API_PATH}/repos/%<owner>s/pulls/%<number>d/reviews".freeze
  COMMENTS_PATH = "#{API_PATH}/repos/%<owner>s/pulls/%<number>d/comments".freeze

  CONTENT_TYPE_HEADER = ['Content-Type', 'application/json'].freeze
  LINK_HEADER = 'link'.freeze
  AUTH_HEADER = 'Authorization'.freeze
  AUTH_TOKEN  = 'token %<token>s'.freeze
  NEXT_LINK_WORD = 'next'.freeze

  def initialize(access_token:)
    @access_token = access_token
  end

  def pull_request_comments(repo, id)
    uri = URI.parse(format(COMMENTS_PATH, owner: repo, number: id))
    Enumerator.new { |yielder| iterate(yielder, link: uri) }
  end

  def create_pull_request_review(repo, id, event:, comments:)
    uri = URI.parse(format(REVIEWS_PATH, owner: repo, number: id))
    make_request(uri, post_request(uri, event: event, comments: comments))
  end

  private

  def iterate(yielder, link:)
    uri = link
    loop do
      response = make_request(uri, get_request(uri))
      JSON.parse(response.body).each { |comment| yielder.yield(comment) }
      break unless next_link?(response[LINK_HEADER])

      uri = URI.parse(next_link(response))
    end
  end

  def next_link?(link)
    link.to_s.include?(NEXT_LINK_WORD)
  end

  def next_link(response)
    response[LINK_HEADER] # <gh.io/r?p=2>; rel="next", <gh.io/r?p=5>; rel="last"
      .split(', ').find(&method(:next_link?)) # <gh.io/r?p=2>; rel="next"
      .split(';').first                       # <gh.io/r?p=2>
      .delete('<>')                           #  gh.io/r?p=2
  end

  def get_request(uri)
    Net::HTTP::Get.new(uri.to_s).tap do |request|
      request.add_field(AUTH_HEADER, format(AUTH_TOKEN, token: @access_token))
    end
  end

  def post_request(uri, body)
    Net::HTTP::Post.new(uri.to_s).tap do |request|
      request.add_field(*CONTENT_TYPE_HEADER)
      request.add_field(AUTH_HEADER, format(AUTH_TOKEN, token: @access_token))
      request.body = body.to_json
    end
  end

  def make_request(uri, request)
    Net::HTTP.new(uri.host, uri.port).tap do |http|
      http.use_ssl = true
    end.request(request)
  end
end
