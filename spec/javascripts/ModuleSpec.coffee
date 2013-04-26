#= require Module

@Module = exports.Module

describe "Module", ->
  module = undefined

  describe "when including in a class", ->
    classCreatedWithModule = (ext) ->
      class
        ext.include(@)

    instanceOfClassCreatedWithModule = (ext) ->
      new (classCreatedWithModule(ext))

    describe ", the included class", ->
      beforeEach ->
        module = class extends Module
          instanceMethod: ->

      it "should have the module's instance methods", ->
        inst = instanceOfClassCreatedWithModule(module)
        expect(inst.instanceMethod).toBeA(Function)
