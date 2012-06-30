class DelegateClass
  @defineDelegate = (receiver, delegated) ->
    receiver[delegated] = () ->
      receiver.accessor(delegated, arguments)

  @factory: (wrappedAttributes...) ->
    class extends DelegateClass
      @wrappedAttributes: wrappedAttributes

      constructor: (@target,attributes) ->
        for attribute in wrappedAttributes
          DelegateClass.defineDelegate this, attribute

          value = attributes[attribute]
          @[attribute](value) if value

  accessor: (property, args) ->
    if args?.length > 0
      @target[property]?(args...)
    else
      @target[property]?()

exports.DelegateClass = DelegateClass
