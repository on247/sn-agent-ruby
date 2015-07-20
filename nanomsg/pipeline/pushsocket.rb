require_relative 'pushsocket.rb'
require_relative 'pullsocket.rb'
module Nanomsg
  module Pipeline
    class PushSocket < Nanomsg::Socket
      def initialize(domain=nil)
        @domain = domain == nil ? NNCore::AF_SP : domain;
        super(@domain,NNCore::NN_PUSH)
      end
    end
  end
end
