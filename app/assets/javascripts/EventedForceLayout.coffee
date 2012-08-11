#= require d3.v2
#= require DelegateClass
#= require underscore
#= require events

@EventEmitter = exports.EventEmitter
@_ = exports._
@DelegateClass = exports.DelegateClass

class EventedForceLayout extends DelegateClass.factory('nodes','links','size','linkDistance','distance','linkStrength','friction','charge','gravity','theta','alpha')

  _.extend @.prototype, EventEmitter.prototype

  constructor: (force,attributes) ->
    super force,attributes
    force.on "tick", @tickEmitter
    @on "tick", attributes.onTick if attributes.onTick?
    @drag = force.drag

  tickEmitter: (properties) =>
    @emit "tick", properties

  start: ->
    @target.start()

exports.EventedForceLayout = EventedForceLayout
