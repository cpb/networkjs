#= require commonjs
#= require events

EventEmitter = exports.EventEmitter

class Network extends EventEmitter
  constructor: ->
    @nodes = []
    @links = []
    @on 'newNode', @addToNetwork

  addNode: (node) ->
    unless @nodeExists(node)
      @nodes.push(node)
      @emit 'newNode', node

  addToNetwork: (node) =>
    if node.targets?
      @nodesByIndex(node.targets...).forEach (target) =>
        @addLink(node, target)

    if node.sources?
      @nodesByIndex(node.sources...).forEach (source) =>
        @addLink(source, node)

  addLink: (source, target) ->
    if not @linkExists(source, target) and @nodesExist(source, target)
      link = {source: source, target: target}
      @links.push(link)
      @emit 'newLink', link

  onNodeArrival: (waitingNode,responder) ->
    if @nodeExists(waitingNode)
      responder.apply(this, @nodesByIndex(waitingNode.index))
    else
      eventResponder = (node) =>
        if node.index == waitingNode.index
          @removeListener 'newNode', eventResponder
          responder.apply(this,[node])

      @on 'newNode', eventResponder

  nodesExist: (nodes...) ->
    nodes.every (node) =>
      @nodeExists(node)

  nodeExists: (node) ->
    @nodes.some (known) ->
      known.index == node.index

  linkExists: (source, target) ->
    @links.some (link) ->
      link.source == source and link.target == target

  nodesByIndex: (indexes...) ->
    @nodes.filter (node) ->
      indexes.some (i) ->
        node.index == i

exports.Network = Network
