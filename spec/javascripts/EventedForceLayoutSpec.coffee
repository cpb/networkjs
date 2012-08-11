#= require EventedForceLayout
#= require helpers/sharedBehaviourForDelegateAccessors

@sharedBehaviourForDelegateAccessors = exports.sharedBehaviourForDelegateAccessors
@EventedForceLayout = exports.EventedForceLayout

describe "EventedForceLayout", ->
  mockTarget = undefined
  eventedForce = undefined
  force = undefined
  nodes = undefined
  links = undefined
  width = undefined
  height = undefined

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
    width = 960
    height = 500
    nodes = [{
    name: "Myriel"
    group: 1
    index: 0
    weight: 10
    x: 482.86738764780745
    y: 288.62173372498404
    px: 482.7046186280315
    py: 288.45958598617983
    fixed: 0
    }
    {
    name: "Napoleon"
    group: 1
    index: 1
    weight: 1
    x: 548.2288710374759
    y: 295.04770906718375
    px: 548.022195964923
    py: 295.0340112520129
    }]

    links = []

    force = d3.layout.force()
    mockTarget = sinon.mock(force)
    eventedForce = new EventedForceLayout(force,attributes)

  it "should delegate start to the force", ->
    mockTarget.expects("start").once()
    expect(calling eventedForce, "start").toVerify(mockTarget)

  it "should have the same drag as the force", ->
    expect(eventedForce.drag).toEqual(force.drag)

  describe "with some nodes and links", ->
    beforeEach ->
      eventedForce = new EventedForceLayout force,
        charge: -240
        linkDistance: 30
        nodes: nodes
        links: links
        size: [width, height]

    it "should emit tick events when the force ticks", ->
      eventedForce.start()
      expect( ->
        force.tick()
      ).toEmitWith(eventedForce,"tick",type: "tick", alpha: 0.099)

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
