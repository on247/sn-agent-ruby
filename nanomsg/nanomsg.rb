require 'nn-core'
require_relative 'nnsocket.rb'
require_relative 'device.rb'
require_relative 'reqrep/reqrep.rb'
require_relative 'pubsub/pubsub.rb'
require_relative 'bus/bussocket.rb'
require_relative 'pair/pairsocket.rb'
require_relative 'pipeline/pipeline.rb'
module Nanomsg
  class Lib
    def errorNumber
       NNCore::LibNanomsg.nn_errno()
    end
    def error()
      currentError = errorNumber()
      NNCore::LibNanomsg.nn_strerror(currentError);
    end
    def terminate
      NNCore::LibNanomsg.nn_term();
    end
  end
end
