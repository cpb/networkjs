#= require EventedForceLayout
#= require helpers/sharedBehaviourForDelegateAccessors

@sharedBehaviourForDelegateAccessors = exports.sharedBehaviourForDelegateAccessors
@EventedForceLayout = exports.EventedForceLayout

describe "EventedForceLayout", ->
  mockTarget = undefined
  eventedForce = undefined
  force = undefined

  attributes =
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

  beforeEach ->
    force = d3.layout.force()
    mockTarget = sinon.mock(force)
    eventedForce = new EventedForceLayout(force,attributes)

  it "should delegate start to the force", ->
    mockTarget.expects("start").once()
    expect(calling eventedForce, "start").toVerify(mockTarget)

  it "should have the same drag as the force", ->
    expect(eventedForce.drag).toEqual(force.drag)

  it "should set the tick responder from the onTick attribute", ->
    tickResponder = ->

    mockTarget.expects("on").withArgs("tick",tickResponder).once()

    expect( ->
      new EventedForceLayout(force,merge(attributes,
        onTick: tickResponder))
    ).toVerify(mockTarget)

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
      accessors: attributes
