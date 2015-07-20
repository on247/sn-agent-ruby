module Nanomsg
  module ReqRep
    class RepSocket < Nanomsg::Socket
      def initialize(domain=nil)
        @domain = domain == nil ? NNCore::AF_SP : domain;
        super(@domain,NNCore::NN_REP)
      end
    end
  end
end
