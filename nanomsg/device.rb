module Nanomsg
  class Device
    def initialize(sourceSocket,destSocket)
      @sourceSocket=sourceSocket;
      @destSocket=sourceSocket;
    end
    def run
      NNCore::LibNanomsg::nn_device(@sourceSocket,@destSocket)
      nil
    end
  end
end
