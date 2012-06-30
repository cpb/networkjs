#= require EventedForceLayout
#= require helpers/sharedBehaviourForDelegateAccessors

@sharedBehaviourForDelegateAccessors = exports.sharedBehaviourForDelegateAccessors
@EventedForceLayout = exports.EventedForceLayout

describe "EventedForceLayout", ->
  delegateAccessors = [
    {accessor: "nodes", value: ["foo"]}
    {accessor: "links", value: ["foo"]}
    {accessor: "theta", value: 0.4}
    {accessor: "alpha", value: 0.4}
    {accessor: "gravity", value: 0.4}
    {accessor: "charge", value: -120}
    {accessor: "friction", value: 0.4}
    {accessor: "linkStrength", value: 0.4}
    {accessor: "distance", value: 30}
    {accessor: "size", value: [10,20]}
  ]

  for context in delegateAccessors
    sharedBehaviourForDelegateAccessors
      describedClass: EventedForceLayout
      delegationTarget: d3.layout.force
      accessor: context.accessor
      value: context.value
      accessors:
        nodes: undefined
        links: undefined
        size: undefined
        linkDistance: undefined
        distance: undefined
        linkStrength: undefined
        friction: undefined
        charge: undefined
        gravity: undefined
        theta: undefined
        alpha: undefined
