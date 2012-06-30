#= require Network

@Network = exports.Network

describe "Network", ->
  network = undefined
  node = undefined
  neighbour = undefined

  beforeEach ->
    network = new Network()
    node = {name: 'foo', targets: [1], index: 0}
    neighbour = {name: 'bar', sources: [0], index: 1}

  describe "#nodes", ->
    it "should return an array", ->
      expect(network.nodes).toBeA(Array)

  describe "#links", ->
    it "should return an array", ->
      expect(network.links).toBeA(Array)

  describe "#addLink", ->
    link = undefined

    beforeEach ->
      link = {source: 'a', target: 'b'}

    addLink = (link) ->
      ->
        network.addLink(link.source, link.target)

    it "should add the link to #links", ->
      expect(addLink(link)).toChange(network.links, 'length')

    it "should emit a newLink event", ->
      expect(addLink(link)).toEmitWith(network,'newLink',{source: 'a', target: 'b'})

    describe "adds only unique links", ->
      beforeEach ->
        addLink(link)()

      it "should not add the link to #links", ->
        expect(addLink(link)).not.toChange(network.links, 'length')

      it "should not emit a newLink event", ->
        expect(addLink(link)).not.toEmitWith(network,'newLink',link)

  describe "#addNode", ->
    addNode = (node) ->
      ->
        network.addNode(node)

    it "should add the node to #nodes", ->
      expect(addNode(node)).toChange(network.nodes,'length')

    it "should emit a newNode event", ->
      expect(addNode(node)).toEmitWith(network,'newNode',node)

    describe "adds only unique nodes", ->
      beforeEach ->
        addNode(node)()

      it "should not add the node to #nodes", ->
        expect(addNode(node)).not.toChange(network.nodes,'length')

      it "should not emit a newNode event", ->
        expect(addNode(node)).not.toEmitWith(network,'newNode',node)

    describe "with a node which does not have its neighbours added yet", ->
      it "should not have any neighbours", ->
        expect(addNode(node)).not.toChange(network.links, 'length')

    describe "with a node which has all its neighbours waiting for it", ->
      beforeEach ->
        addNode(node)()

      it "should add a link", ->
        expect(addNode(neighbour)).toChange(network.links, 'length')
        expect(network.links).toContain({source: node, target: neighbour})
