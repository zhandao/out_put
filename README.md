# OutPut

[![Gem Version](https://badge.fury.io/rb/out_put.svg)](https://badge.fury.io/rb/out_put)

Render JSON response in a unified format

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'out_put'
```

And then execute:

    $ bundle

## Usage

### Config

initializers: `out_put.rb`

```ruby
OutPut::Config.tap do |config|
  config.project_code = 101000 # MUST padding three zero here
  config.pagination_for = :list
end
```

### Basic

if your controller does **not** inherit from `ActionController::API`:

```ruby
include OutPut
```

To render a json response, call `output` method, it's very easy:

```ruby
output 0, 'success'
# the same as above:
output code: 0, msg: 'success'
# will render by the default format:
# {
#   result: { code: 0, message: 'success' }
# }

ok # => code: 0, message: 'success'
```

### Response `data` filed

```ruby
output 0, foo: 'bar', list: [ 1, 2, 3 ]
# will render by the default format:
# {
#   result: { code: 0, message: '' }
#     data: { foo: 'bar', list: [1,2,3] }
# }

# or
ok_with foo: 'bar'
```

### Set HTTP status

```ruby
output 0, 'success', http: 200
```

### Error Response

You don't need to pass your project code like '101', after **config**:

```ruby
error 700, 'the 7th api error 0' # => the final code will be 101700
# or
error_with 700, 'msg', foo: 'bar'
```

`error` is an alias of `output`

### `output` any objects which have implemented serialization method `info`

```ruby
BusinessError.record_not_found.info # => { code: ..., msg: ... }

output BusinessError.record_not_found
```

[About `business_error`](https://github.com/zhandao/business_error/)

### Just render the given data without default format

```ruby
output only: { foo: 'bar' }
# will render: { foo: 'bar' }

# response an array
output only: [ 1, 2, 3 ]
```

### Other

#### 1. automatically set `total`:

if `config.pagination_for = :list`:

```ruby
output 0, list: [ 1, 2, 3 ]
# will render:
# {
#   result: { code: 0, message: '' }
#     data: { total: 3, list: [1,2,3] }
# }
```
