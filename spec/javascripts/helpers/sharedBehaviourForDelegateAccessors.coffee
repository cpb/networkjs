#= require coffee-script/helpers
#= require helpers/CoreExtensions
@calling = exports.calling
@merge = exports.merge
@except = exports.except

exports.sharedBehaviourForDelegateAccessors = (sharedSetup) ->
  contextClass = class
    constructor: (setup) ->
      @describedClass = setup.describedClass
      @_delegationTarget = setup.delegationTarget
      @accessors = setup.accessors
      @accessor = setup.accessor
      @value = setup.value

    delegationTarget: () ->
      unless @memo_delegationTarget?
        @memo_delegationTarget = @_delegationTarget()
      @memo_delegationTarget

    initialized: (attributes) =>
      new @describedClass(@delegationTarget(),attributes)

    initialize: (attributes) =>
      =>
        @initialized(attributes)


  context = new contextClass(sharedSetup)

  describe "##{context.accessor}", ->
    accessor = undefined
    accessor_value = undefined
    accessors = undefined
    delegationTarget = undefined
    initialize = undefined
    initialized = undefined
    target = undefined
    value = undefined

    afterEach ->
      target.restore()

    beforeEach ->
      accessor = context.accessor
      accessor_value = {}
      accessors = context.accessors
      delegationTarget = context.delegationTarget()
      initialize = context.initialize
      initialized = context.initialized
      target = sinon.mock(context.delegationTarget())
      value = context.value
      accessor_value[accessor] = value

    it "should set #{context.accessor} when initializing with #{context.accessor}", ->
      target.expects(accessor).once().withArgs()#.withExactArgs(value)
      expect(initialize(merge(accessors, accessor_value)))
        .toVerify(target)

    it "should not set #{context.accessor} when #{context.accessor} is not provided", ->
      target.expects(accessor).never()
      expect(initialize(except(accessors, accessor)))
        .toVerify(target)

    describe "after initialization", ->
      instance = undefined

      beforeEach ->
        instance = initialized(merge(accessors, accessor_value))

      it "should delegate the #{context.accessor} reader", ->
        target.expects(accessor).once()
        expect(calling instance, accessor).toVerify(target)

      it "should delegate the #{context.accessor} writer", ->
        target.expects(accessor).once().withArgs()#.withExactArgs(value)
        expect(calling instance, accessor, value).toVerify(target)
