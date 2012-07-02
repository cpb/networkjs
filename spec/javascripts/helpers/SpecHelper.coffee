beforeEach ->
  this.addMatchers
    toBeA: (expectedClass) ->
      @message = ->
        if @actual
          "#{@actual.constructor} does not match #{expectedClass.name}"
        else
          "undefined does not match #{expectedClass.name}"

      @actual instanceof expectedClass

    toVerify: (mock) ->
      @actual?()

      @message = ->
        ["Expected not to fail but failed",
         "Expect to fail but passed"]

      if mock instanceof Function
        mock()
      else
        mock.verify()

    toChange: () ->
      if arguments[0] instanceof Function
        @expressionMessage = @expression = arguments[0]
      else
        @expressionMessage = arguments[1]
        @receiver = arguments[0]
        @expression = ->
          @receiver[@expressionMessage]

      @before = @expression()
      @actual?()
      @after = @expression()

      @message = ->
        ["Expected #{@expressionMessage} to change, but it is still #{jasmine.pp(@before)}",
         "Expected #{@expressionMessage} to not change, but it changed from #{jasmine.pp(@before)} to #{jasmine.pp(@after)}"]


      @before != @after
    toEmitWith: (emitter,event,args) ->
      @listener = sinon.spy()

      emitter.on?(event,@listener)

      @actual?()

      @message = ->
        failCall = @listener.getCall(0)
        if failCall?
          ["Expected #{emitter.constructor.name} to emit #{event} with #{jasmine.pp(args)}, but was emitted with #{jasmine.pp(failCall.args)}",
          "expected #{emitter.constructor.name} to not emit #{event} with #{jasmine.pp(args)}, but was emitted"]
        else
          ["Expected #{emitter.constructor.name} to emit #{event} with #{jasmine.pp(args)}, but was not emitted",
          "Expected #{emitter.constructor.name} to not emit #{event} with #{jasmine.pp(args)}, but was emitted"]

      @listener.calledWith(args)
    toEmitWithExactly: (emitter,event,args) ->
      @listener = sinon.spy()

      emitter.on?(event,@listener)

      @actual?()

      @message = ->
        failCall = @listener.getCall(0)
        "Expected #{emitter.constructor.name} to emit #{event} with #{jasmine.pp(args)}, but was called with #{jasmine.pp(failCall.args)}"

      @listener.calledWithExactly(args)
