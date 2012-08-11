class DelegateClass
  @defineDelegate = (receiver, delegated) ->
    receiver[delegated] = () ->
      receiver.accessor(delegated, arguments)

  @accessor: (property, args) ->
    if args?.length > 0
      @target[property]?(args...)
    else
      @target[property]?()

  @factory: (wrappedAttributes..., delegationStrategy) ->
    unless delegationStrategy instanceof Function
      wrappedAttributes.push(delegationStrategy)
      delegationStrategy = @accessor

    class
      @wrappedAttributes: wrappedAttributes

      constructor: (@target,attributes) ->
        for attribute in wrappedAttributes
          DelegateClass.defineDelegate this, attribute

          value = attributes[attribute]
          @[attribute](value) if value

      accessor: delegationStrategy


exports.DelegateClass = DelegateClass
