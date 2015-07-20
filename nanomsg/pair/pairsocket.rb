module Nanomsg
  module Pair
    class PairSocket < Nanomsg::Socket
      def initialize(domain=nil)
        @domain = domain == nil ? NNCore::AF_SP : domain;
        super(@domain,NNCore::NN_PAIR)
      end
    end
  end
end
