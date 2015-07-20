module Framework
  class AgentInterface
    @name
    @methods
    @pubmethods
    @authmethods
    attr_accessor :name
    attr_accessor :methods
    attr_accessor :pubmethods
    attr_accessor :authmethods
    @register
    @processRegister
    @idle
    @process
    @shutdown
    attr_accessor :register
    attr_accessor :processRegister
    attr_accessor :idle
    attr_accessor :process
    attr_accessor :shutdown
    def register(info,args)
      @register.call(info,args)
    end
    def processRegister(info,data)
      @processRegister.call(info,data)
    end
    def idle(info)
      @idle.call(info)
    end
    def process(info,data)
      @process.call(info,data)
    end
    def shutdown(info,retcode)
      @shutdown.call(info,retcode)
    end
  end
end
