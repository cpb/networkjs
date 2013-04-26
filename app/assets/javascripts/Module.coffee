#= require commonjs
#= require underscore

@_ = exports._

class Module
  @include = (klass) ->
    _.extend(klass.prototype, @.prototype)

exports.Module = Module
