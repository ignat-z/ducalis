## Ducalis::CallbacksActiverecord

Please, avoid using of callbacks for models. It's better to keep models small ("dumb") and instead use "builder" classes/services: to construct new objects. You can read more [here](https://medium.com/planet-arkency/a61fd75ab2d3).
- rejects ActiveRecord classes which contains callbacks
```ruby
class A < ActiveRecord::Base
  before_create :generate_code
end
```
- ignores non-ActiveRecord classes which contains callbacks
```ruby
class A < SomeBasicClass
  before_create :generate_code
end
```
## Ducalis::KeywordDefaults

Prefer to use keyword arguments for defaults. It increases readability and reduces ambiguities.
- rejects if method definition contains default values
```ruby
def some_method(a, b, c = 3); end
```
- rejects if class method definition contains default values
```ruby
def self.some_method(a, b, c = 3); end
```
- works if method definition contains default values through keywords
```ruby
def some_method(a, b, c: 3); end
```
- works for methods without arguments
```ruby
def some_method; end
```
- works for class methods without arguments
```ruby
def self.some_method; end
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
- raise if somewhere AR search was called on not protected scope
```ruby
Group.find(8)
```
- raise if AR search was called even for chain of calls
```ruby
Group.includes(:some_relation).find(8)
```
- works ignores where statements and still raises error
```ruby
Group.includes(:some_relation).where(name: "John").find(8)
```
## Ducalis::RegexCop

It's better to move regex to constants with example instead of direct using it.
It will allow you to reuse this regex and provide instructions for others.

```ruby
CONST_NAME = %<constant>s # "%<example>s"
%<fixed_string>s
```
- raise if somewhere in code used regex which is not moved to const
```ruby

name = "john"
puts "hi" if name =~ /john/

```
- accepts matching constants
```ruby

REGEX = /john/
name = "john"
puts "hi" if name =~ REGEX

```
- ignores named ruby constants
```ruby

name = "john"
puts "hi" if name =~ /[[:alpha:]]/

```
- ignores dynamic regexs
```ruby

name = "john"
puts "hi" if name =~ /.{#{name.length}}/

```
## Ducalis::RestOnlyCop

It's better for controllers to stay adherent to REST:
http://jeromedalbert.com/how-dhh-organizes-his-rails-controllers/
- raise for controllers with non-REST methods
```ruby

class MyController < ApplicationController
  def index; end
  def non_rest_method; end
end

```
- doesn't raise for controllers with private non-REST methods
```ruby

class MyController < ApplicationController
  def index; end
  private
  def non_rest_method; end
end

```
- doesn't raise for controllers with only REST methods
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
- doesn't raise for non-controllers with non-REST methods
```ruby

class MyClass
  def index; end
  def non_rest_method; end
end

```
## Ducalis::RubocopDisable


Please, do not suppress RuboCop metrics, may be you can introduce some refactoring or another concept.
    
- raises on RuboCop disable comments
```ruby

# rubocop:disable Metrics/ParameterLists
def some_method(a, b, c, d, e, f); end

```
- doesnt raise on comment without RuboCop disabling
```ruby

# some meaningful comment
def some_method(a, b, c, d, e, f); end

```
## Ducalis::StringsInActiverecords

Please, do not use strings as arguments for %<method_name>s argument.
It's hard to test, grep sources, code highlighting and so on.
Consider using of symbols or lambdas for complex expressions.
- raise for string if argument
```ruby

before_save :set_full_name, 
 if: 'name_changed? || postfix_name_changed?'

```
- doesnt raise for lambda if argument
```ruby
validates :file, if: -> { remote_url.blank? }
```
## Ducalis::UncommentedGem

Please, add comment why are you including non-realized gem version for %<gem>s.
It will increase [bus-factor](<https://en.wikipedia.org/wiki/Bus_factor>).
- raise for gem from github without comment
```ruby

gem 'a' 
gem 'b', '~> 1.3.1' 
gem 'c', git: 'https://github.com/c/c'

```
- doesn't raise for gem from github with comment
```ruby

gem 'a' 
gem 'b', '~> 1.3.1' 
gem 'c', git: 'https://github.com/c/c' # some description

```