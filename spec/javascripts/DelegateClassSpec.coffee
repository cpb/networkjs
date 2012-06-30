#= require DelegateClass
#= require helpers/sharedBehaviourForDelegateAccessors

@sharedBehaviourForDelegateAccessors = exports.sharedBehaviourForDelegateAccessors
@DelegateClass = exports.DelegateClass

describe "DelegateClass", ->
  sharedBehaviourForDelegateAccessors
    delegationTarget: -> 
      delegated = class
        foo: (newFoo)->
          if newFoo?
            @_foo = newFoo

          @_foo

      new delegated()
    describedClass: class extends DelegateClass.factory("foo")
      bar: (newBar) ->
        if newBar?
          @_bar = newBar

        @_bar
    accessor: "foo"
    value: "bar"
    accessors:
      foo: undefined
