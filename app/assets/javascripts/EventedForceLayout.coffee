#= require d3.v2
#= require DelegateClass

DelegateClass = exports.DelegateClass

class EventedForceLayout extends DelegateClass.factory('nodes','links','size','linkDistance','distance','linkStrength','friction','charge','gravity','theta','alpha')

  constructor: (force,attributes) ->
    super(force,attributes)
    force.on("tick", attributes.onTick) if attributes.onTick?
    @drag = force.drag

  start: ->
    @target.start()

exports.EventedForceLayout = EventedForceLayout
