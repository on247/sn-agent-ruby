module Nanomsg
  module PubSub
    class PubSocket < Nanomsg::Socket
      def initialize(domain=nil)
        @domain = domain == nil ? NNCore::AF_SP : domain;
        super(@domain,NNCore::NN_PUB)
      end
    end
  end
end
