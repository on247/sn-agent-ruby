module Nanomsg
  module ReqRep
    class ReqSocket < Nanomsg::Socket
      def initialize(domain=nil)
        @domain = domain == nil ? NNCore::AF_SP : domain;
        super(@domain,NNCore::NN_REQ)
      end
    end
  end
end
