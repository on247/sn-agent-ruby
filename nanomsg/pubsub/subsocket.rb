module Nanomsg
  module PubSub
    class SubSocket < Nanomsg::Socket
      def initialize(domain=nil)
        @domain = domain == nil ? NNCore::AF_SP : domain;
        super(@domain,NNCore::NN_SUB)
      end
    end
  end
end
