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

  describe "#nodesExist", ->
    ninetyNine = undefined
    eightyEight = undefined
    seventySeven = undefined
    sixtySix = undefined

    beforeEach ->
      ninetyNine = {index: 99}
      eightyEight = {index: 88}
      seventySeven = {index: 77}
      sixtySix = {index: 66}

      network.addNode(ninetyNine)
      network.addNode(eightyEight)
      network.addNode(seventySeven)

    describe "with each present", ->
      it "should be true", ->
        expect(network.nodesExist(ninetyNine)).toBeTruthy()
        expect(network.nodesExist(eightyEight)).toBeTruthy()
        expect(network.nodesExist(seventySeven)).toBeTruthy()
        expect(network.nodesExist(ninetyNine,eightyEight)).toBeTruthy()
        expect(network.nodesExist(eightyEight,seventySeven)).toBeTruthy()
        expect(network.nodesExist(seventySeven,ninetyNine)).toBeTruthy()
        expect(network.nodesExist(ninetyNine,eightyEight,seventySeven)).toBeTruthy()
        expect(network.nodesExist(eightyEight,seventySeven,ninetyNine)).toBeTruthy()
        expect(network.nodesExist(seventySeven,ninetyNine,eightyEight)).toBeTruthy()

    describe "with some missing", ->
      it "should be false", ->
        expect(network.nodesExist(sixtySix)).toBeFalsy()
        expect(network.nodesExist(ninetyNine,sixtySix)).toBeFalsy()
        expect(network.nodesExist(sixtySix,seventySeven)).toBeFalsy()
        expect(network.nodesExist(ninetyNine,eightyEight,sixtySix)).toBeFalsy()
        expect(network.nodesExist(eightyEight,sixtySix,ninetyNine)).toBeFalsy()
        expect(network.nodesExist(sixtySix,ninetyNine,eightyEight)).toBeFalsy()

  describe "#addLink", ->
    link = undefined

    beforeEach ->
      link = {source: {index: 99}, target: {index: 88}}

    addLink = (link) ->
      ->
        network.addLink(link.source, link.target)

    describe "adds only unique links", ->
      beforeEach ->
        addLink(link)()

      it "should not add the link to #links", ->
        expect(addLink(link)).not.toChange(network.links, 'length')

      it "should not emit a newLink event", ->
        expect(addLink(link)).not.toEmitWith(network,'newLink',link)

    describe "when both nodes are present", ->
      beforeEach ->
        network.addNode({index: 88})
        network.addNode({index: 99})

      it "should add the link to #links", ->
        expect(addLink(link)).toChange(network.links, 'length')

      it "should emit a newLink event", ->
        expect(addLink(link)).toEmitWith(network,'newLink',link)

    describe "when both nodes are missing", ->
      it "should not add the links to #links", ->
        expect(addLink(link)).not.toChange(network.links, 'length')

      it "should not emit a newLink event", ->
        expect(addLink(link)).not.toEmitWith(network,'newLink',link)

    describe "when one node is present", ->
      beforeEach ->
        network.addNode({index: 88})

      it "should not add the links to #links", ->
        expect(addLink(link)).not.toChange(network.links, 'length')

      it "should not emit a newLink event", ->
        expect(addLink(link)).not.toEmitWith(network,'newLink',link)

  describe "#onNodeArrival", ->
    spy = undefined
    beforeEach ->
      spy = sinon.spy()

    describe "when the node is not yet there", ->
      beforeEach ->
        network.onNodeArrival({index: node.index},spy)

      it "should invoke responders for the node", ->
        expect(->
          network.emit("newNode",node)
        ).toVerify(-> spy.calledWith(node) and spy.calledOn(network))

      it "should not invoke responders for other nodes", ->
        expect(->
          network.emit("newNode",neighbour)
        ).not.toVerify(-> spy.calledWith(node) and spy.calledOn(network))

      it "should only invoke responders once", ->
        network.emit("newNode",node)
        spy.reset()
        expect(->
          network.emit("newNode",node)
        ).not.toVerify(-> spy.calledWith(node) and spy.calledOn(network))

    describe "when the node is already there", ->
      beforeEach ->
        network.addNode(node)

      it "should invoke responder right away", ->
        expect(->
          network.onNodeArrival({index: node.index},spy)
        ).toVerify(-> spy.calledWith(node) and spy.calledOn(network))

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

      describe "and then its source neighbours arrive", ->
        beforeEach ->
          addNode(neighbour)()

        describe "with a reference to the waiting node", ->
          it "should then have a neighbour", ->
            expect(addNode(node)).toChange(network.links, 'length')

        describe "without a reference to the waiting node", ->
          it "should then have a neighbour", ->
            expect(addNode(except(node, 'targets'))).toChange(network.links, 'length')

      describe "and then its target neighbours arrive", ->
        beforeEach ->
          addNode(node)()

        describe "with a reference to the waiting node", ->
          it "should then have a neighbour", ->
            expect(addNode(neighbour)).toChange(network.links, 'length')

        describe "without a reference to the waiting node", ->
          it "should then have a neighbour", ->
            expect(addNode(except(neighbour, 'sources'))).toChange(network.links, 'length')

    describe "with a node which has all its neighbours waiting for it", ->
      beforeEach ->
        addNode(node)()

      it "should add a link", ->
        expect(addNode(neighbour)).toChange(network.links, 'length')
        expect(network.links).toContain({source: node, target: neighbour})
