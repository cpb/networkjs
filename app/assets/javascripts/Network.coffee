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
      @emit 'newNode', node
      @nodes.push(node)

  addToNetwork: (node) =>
    if node.targets?
      @nodesByIndex(node.targets...).forEach (target) =>
        @addLink(node, target)

    if node.sources?
      @nodesByIndex(node.sources...).forEach (source) =>
        @addLink(source, node)

  addLink: (source, target) ->
    unless @linkExists(source, target)
      link = {source: source, target: target}
      @emit 'newLink', link
      @links.push(link)

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
