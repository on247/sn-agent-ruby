module Nanomsg
  module Bus
    class BusSocket < Nanomsg::Socket
      def initialize(domain=nil)
        @domain = domain == nil ? NNCore::AF_SP : domain;
        super(@domain,NNCore::NN_BUS)
      end
    end
  end
end
