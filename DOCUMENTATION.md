## Ducalis::CallbacksActiverecord

Please, avoid using of callbacks for models. It's better to keep models small ("dumb") and instead use "builder" classes/services: to construct new objects. You can read more [here](https://medium.com/planet-arkency/a61fd75ab2d3).

![](https://placehold.it/15/f03c15/000000?text=+) raises on ActiveRecord classes which contains callbacks
```ruby

class A < ActiveRecord::Base
  before_create :generate_code
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores non-ActiveRecord classes which contains callbacks
```ruby

class A < SomeBasicClass
  before_create :generate_code
end

```
## Ducalis::CaseMapping

Try to avoid `case when` statements. You can replace it with a sequence of
`if... elsif... elsif... else`. For cases where you need to choose from a
large number of possibilities, you can create a dictionary mapping case values
to functions to call by `call`. It's nice to have prefix for the method
names, i.e.: `visit_`.

<details>
Usually `case when` statements are using for the next reasons:

I. Mapping between different values.
("A" => 1, "B" => 2, ...)

This case is all about data representing. If you do not need to execute any code
it's better to use data structure which represents it. This way you are
separating concepts: code returns corresponding value and you have config-like
data structure which describes your data.

```ruby
  %w[A B ...].index("A") + 1
  # or
  { "A" => 1, "B" => 2 }.fetch("A")
```

II. Code execution depending of parameter or type:

  - a. (:attack => attack, :defend => defend)
  - b. (Feet => value * 0.348, Meters => `value`)

In this case code violates OOP and S[O]LID principle. Code shouldn't know about
object type and classes should be open for extension, but closed for
modification (but you can't do it with case-statements).
This is a signal that you have some problems with architecture.

  a.
```ruby
attack: -> { execute_attack }, defend: -> { execute_defend }
# or
call(:"execute_#{action}")
```

  b.
```ruby
class Meters; def to_metters; value;         end
class Feet;   def to_metters; value * 0.348; end
```

III. Code execution depending on some statement.
(`a > 0` => 1, `a == 0` => 0, `a < 0` => -1)

This case is combination of I and II -- high code complexity and unit-tests
complexity. There are variants how to solve it:

  a. Rewrite to simple if statement

```ruby
return 0 if a == 0
a > 0 ? 1 : -1
```

  b. Move statements to lambdas:

```ruby
 ->(a) { a > 0 }  =>  1,
 ->(a) { a == 0 } =>  0,
 ->(a) { a < 0 }  => -1
```

This way decreases code complexity by delegating it to lambdas and makes it easy
 to unit-testing because it's easy to test pure lambdas.

Such approach is named
[table-driven design](<https://www.d.umn.edu/~gshute/softeng/table-driven.html>)
. Table-driven methods are schemes that allow you to look up information in a
table rather than using logic statements (i.e. case, if). In simple cases,
it's quicker and easier to use logic statements, but as the logic chain becomes
more complex, table-driven code is simpler than complicated logic, easier to
modify and more efficient.
</details>

![](https://placehold.it/15/f03c15/000000?text=+) raises on case statements
```ruby

case grade
when "A"
  puts "Well done!"
when "B"
  puts "Try harder!"
when "C"
  puts "You need help!!!"
else
  puts "You just making it up!"
end

```
## Ducalis::ControllersExcept

Prefer to use `:only` over `:except` in controllers because it's more explicit and will be easier to maintain for new developers.

![](https://placehold.it/15/f03c15/000000?text=+) raises for `before_filters` with `except` method as array
```ruby

class MyController < ApplicationController
  before_filter :something, except: [:index]
  def index; end
  def edit; end
  private
  def something; end
end

```

![](https://placehold.it/15/f03c15/000000?text=+) raises for filters with many actions and only one `except` method
```ruby

class MyController < ApplicationController
  before_filter :something, :load_me, except: %i[edit]
  def index; end
  def edit; end
  private
  def something; end
  def load_me; end
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores `before_filters` without arguments
```ruby

class MyController < ApplicationController
  before_filter :something
  def index; end
  private
  def something; end
end

```
## Ducalis::KeywordDefaults

Prefer to use keyword arguments for defaults. It increases readability and reduces ambiguities.

![](https://placehold.it/15/f03c15/000000?text=+) raises if method definition contains default values
```ruby
def some_method(a, b, c = 3); end
```

![](https://placehold.it/15/f03c15/000000?text=+) raises if class method definition contains default values
```ruby
def self.some_method(a, b, c = 3); end
```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores if method definition contains default values through keywords
```ruby
def some_method(a, b, c: 3); end
```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores for methods without arguments
```ruby
def some_method; end
```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores for class methods without arguments
```ruby
def self.some_method; end
```
## Ducalis::ModuleLikeClass

Seems like it will be better to define initialize and pass %<args>s there instead of each method.

![](https://placehold.it/15/f03c15/000000?text=+) raises if class doesn't contain constructor but accept the same args
```ruby

class MyClass

  def initialize(customer)
    # ...
  end

  def approve(task, estimate, some_args_1)
    # ...
  end

  def decline(user, task, estimate, some_args_2)
    # ...
  end

  private

  def anything_you_want(args)
    # ...
  end
end

```

![](https://placehold.it/15/f03c15/000000?text=+) raises for class with only one public method with args
```ruby

class MyClass
  def approve(task)
    # ...
  end

  private

  def anything_you_want(args)
    # ...
  end
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores classes with custom includes
```ruby

class MyClass
  include Singleton

  def approve(task)
    # ...
  end
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores classes with inheritance
```ruby

class MyClass < AnotherClass
  def approve(task)
    # ...
  end

  private

  def anything_you_want(args)
    # ...
  end
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores classes with one method and initializer
```ruby

class MyClass
  def initialize(task)
    # ...
  end

  def call(args)
    # ...
  end
end

```
## Ducalis::ParamsPassing

It's better to pass already preprocessed params hash to services. Or you can use
`arcane` gem

![](https://placehold.it/15/f03c15/000000?text=+) raises if user pass `params` as argument from controller
```ruby

class MyController < ApplicationController
  def index
    MyService.new(params).call
  end
end

```

![](https://placehold.it/15/f03c15/000000?text=+) raises if user pass `params` as any argument from controller
```ruby

class MyController < ApplicationController
  def index
    MyService.new(first_arg, params).call
  end
end

```

![](https://placehold.it/15/f03c15/000000?text=+) raises if user pass `params` as keyword argument from controller
```ruby

class MyController < ApplicationController
  def index
    MyService.new(first_arg, any_name: params).call
  end
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores passing only one `params` field
```ruby

class MyController < ApplicationController
  def index
    MyService.new(first_arg, params[:id]).call
  end
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores passing processed `params`
```ruby

class MyController < ApplicationController
  def index
    MyService.new(first_arg, params.slice(:name)).call
  end
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores passing `params` from `arcane` gem
```ruby

class MyController < ApplicationController
  def index
    MyService.new(params.for(Log).as(user).refine).call
  end
end

```
## Ducalis::PossibleTap

Consider of using `.tap`, default ruby [method](<https://apidock.com/ruby/Object/tap>) which allows to replace intermediate variables with block, by this you are limiting scope pollution and make scope more clear. [Related article](<http://seejohncode.com/2012/01/02/ruby-tap-that/>).

![](https://placehold.it/15/f03c15/000000?text=+) raises for methods with scope variable return
```ruby

def load_group
  group = channel.groups.find(params[:group_id])
  authorize group, :edit?
  group
end

```

![](https://placehold.it/15/f03c15/000000?text=+) raises for methods with instance variable changes and return
```ruby

def load_group
  @group = Group.find(params[:id])
  authorize @group
  @group
end

```

![](https://placehold.it/15/f03c15/000000?text=+) raises for methods with instance variable `||=` assign and return
```ruby

def define_roles
  return [] unless employee

  @roles ||= []
  @roles << "primary"  if employee.primary?
  @roles << "contract" if employee.contract?
  @roles
end

```

![](https://placehold.it/15/f03c15/000000?text=+) raises for methods which return call on scope variable
```ruby

def load_group
  elections = @elections.group_by(&:code)
  result = elections.map do |code, elections|
    { code => statistic }
  end
  result << total_spend(@elections)
  result.inject(:merge)
end

```

![](https://placehold.it/15/f03c15/000000?text=+) raises for methods which return instance variable but have scope vars
```ruby

def generate_file(file_name)
  @file = Tempfile.new([file_name, ".pdf"])
  signed_pdf = some_new_stuff
  @file.write(signed_pdf.to_pdf)
  @file.close
  @file
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores empty methods
```ruby

def edit
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores methods which body is just call
```ruby

def total_cost(cost_field)
  Service.cost_sum(cost_field)
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores methods which return some statement
```ruby

  def stop_terminated_employee
  if current_user && current_user.terminated?
    sign_out current_user
    redirect_to new_user_session_path
  end
end


```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores methods which simply returns instance var without changes
```ruby

def employee
  @employee
end

```
## Ducalis::PrivateInstanceAssign

Please, don't assign instance variables in controller's private methods. It's make hard to understand what variables are available in views.

![](https://placehold.it/15/f03c15/000000?text=+) raises for assigning instance variables in controllers private methods
```ruby

class MyController < ApplicationController
  private

  def load_employee
    @employee = Employee.find(params[:id])
  end
end

```

![](https://placehold.it/15/f03c15/000000?text=+) raises for memoization variables in controllers private methods
```ruby

class MyController < ApplicationController
  private

  def service
    @service ||= Service.new
  end
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores memoization variables in controllers private methods with _
```ruby

class MyController < ApplicationController
  private

  def service
    @_service ||= Service.new
  end
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores assigning instance variables in controllers public methods
```ruby

class MyController < ApplicationController
  def index
    @employee = load_employee
  end

  private

  def load_employee
    Employee.find(params[:id])
  end
end

```
## Ducalis::ProtectedScopeCop

Seems like you are using `find` on non-protected scope. Potentially it could
lead to unauthorized access. It's better to call `find` on authorized resources
scopes. Example:

```ruby
current_group.employees.find(params[:id])
# better then
Employee.find(params[:id])
```

![](https://placehold.it/15/f03c15/000000?text=+) raises if somewhere AR search was called on not protected scope
```ruby
Group.find(8)
```

![](https://placehold.it/15/f03c15/000000?text=+) raises if AR search was called even for chain of calls
```ruby
Group.includes(:some_relation).find(8)
```

![](https://placehold.it/15/f03c15/000000?text=+) ignores where statements and still raises error
```ruby
Group.includes(:some_relation).where(name: "John").find(8)
```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores find method with passed block
```ruby
MAPPING.find { |x| x == 42 }
```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores find method with passed multiline block
```ruby

MAPPING.find do |x|
  x == 42
end

```
## Ducalis::RaiseWithourErrorClass

It's better to add exception class as raise argument. It will make easier to catch and process it later.

![](https://placehold.it/15/f03c15/000000?text=+) raises when `raise` called without exception class
```ruby
raise "Something went wrong"
```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores when `raise` called with exception class
```ruby
raise StandardError, "Something went wrong"
```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores when `raise` called with exception instance
```ruby
raise StandardError.new("Something went wrong")
```
## Ducalis::RegexCop

It's better to move regex to constants with example instead of direct using it.
It will allow you to reuse this regex and provide instructions for others.

```ruby
CONST_NAME = %<constant>s # "%<example>s"
%<fixed_string>s
```

![](https://placehold.it/15/f03c15/000000?text=+) raises if somewhere in code used regex which is not moved to const
```ruby

name = "john"
puts "hi" if name =~ /john/

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores matching constants
```ruby

REGEX = /john/
name = "john"
puts "hi" if name =~ REGEX

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores named ruby constants
```ruby

name = "john"
puts "hi" if name =~ /[[:alpha:]]/

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores dynamic regexs
```ruby

name = "john"
puts "hi" if name =~ /.{#{name.length}}/

```
## Ducalis::RestOnlyCop

It's better for controllers to stay adherent to REST:
http://jeromedalbert.com/how-dhh-organizes-his-rails-controllers/

![](https://placehold.it/15/f03c15/000000?text=+) raises for controllers with non-REST methods
```ruby

class MyController < ApplicationController
  def index; end
  def non_rest_method; end
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores controllers with private non-REST methods
```ruby

class MyController < ApplicationController
  def index; end
  private
  def non_rest_method; end
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores controllers with only REST methods
```ruby

class MyController < ApplicationController
  def index; end
  def show; end
  def new; end
  def edit; end
  def create; end
  def update; end
  def destroy; end
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores non-controllers with non-REST methods
```ruby

class MyClass
  def index; end
  def non_rest_method; end
end

```
## Ducalis::RubocopDisable


Please, do not suppress RuboCop metrics, may be you can introduce some refactoring or another concept.
    

![](https://placehold.it/15/f03c15/000000?text=+) raises on RuboCop disable comments
```ruby

# rubocop:disable Metrics/ParameterLists
def some_method(a, b, c, d, e, f); end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores comment without RuboCop disabling
```ruby

# some meaningful comment
def some_method(a, b, c, d, e, f); end

```
## Ducalis::StringsInActiverecords

Please, do not use strings as arguments for %<method_name>s argument.
It's hard to test, grep sources, code highlighting and so on.
Consider using of symbols or lambdas for complex expressions.

![](https://placehold.it/15/f03c15/000000?text=+) raises for string if argument
```ruby

before_save :set_full_name, 
 if: 'name_changed? || postfix_name_changed?'

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores lambda if argument
```ruby
validates :file, if: -> { remote_url.blank? }
```
## Ducalis::UncommentedGem

Please, add comment why are you including non-realized gem version for %<gem>s.
It will increase [bus-factor](<https://en.wikipedia.org/wiki/Bus_factor>).

![](https://placehold.it/15/f03c15/000000?text=+) raises for gem from github without comment
```ruby

gem 'a' 
gem 'b', '~> 1.3.1' 
gem 'c', git: 'https://github.com/c/c'

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores for gem from github with comment
```ruby

gem 'a' 
gem 'b', '~> 1.3.1' 
gem 'c', git: 'https://github.com/c/c' # some description

```
## Ducalis::UselessOnly

Seems like there is no any reason to keep before filter only for one action. Maybe it will be better to inline it?

```ruby
before_filter :do_something, only: %i[index]
def index; end

# to

def index
  do_something
end
```

![](https://placehold.it/15/f03c15/000000?text=+) raises for `before_filters` with only one method as array
```ruby

class MyController < ApplicationController
  before_filter :do_something, only: [:index]
  def index; end
  private
  def do_something; end
end

```

![](https://placehold.it/15/f03c15/000000?text=+) raises for `before_filters` with only one method as keyword array
```ruby

class MyController < ApplicationController
  before_filter :do_something, only: %i[index]
  def index; end
  private
  def do_something; end
end

```

![](https://placehold.it/15/f03c15/000000?text=+) raises for `before_filters` with many actions and only one method
```ruby

class MyController < ApplicationController
  before_filter :do_something, :load_me, only: %i[index]
  def index; end
  private
  def do_something; end
  def load_me; end
end

```

![](https://placehold.it/15/f03c15/000000?text=+) raises for `before_filters` with only one method as argument
```ruby

class MyController < ApplicationController
  before_filter :do_something, only: :index
  def index; end
  private
  def do_something; end
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores `before_filters` without arguments
```ruby

class MyController < ApplicationController
  before_filter :do_something
  def index; end
  private
  def do_something; end
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores `before_filters` with `only` and many arguments
```ruby

class MyController < ApplicationController
  before_filter :do_something, only: %i[index show]
  def index; end
  def show; end
  private
  def do_something; end
end

```

![](https://placehold.it/15/2cbe4e/000000?text=+) ignores `before_filters` with `except` and one argument
```ruby

class MyController < ApplicationController
  before_filter :do_something, except: %i[index]
  def index; end
  private
  def do_something; end
end

```