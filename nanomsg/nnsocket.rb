module Nanomsg
  class SocketError < StandardError
    def initialize(errno,msg)
      @errno=errno
      @msg=msg
    end
  end
  class Socket
    @closed=false
    @opened=false
    def initialize(domain,protocol)
      @socket=NNCore::LibNanomsg::nn_socket(domain,protocol)
      @opened = true
      setSendtimeout(600)
      setRecvtimeout(600)
    end
    def getNativeSocket
      @socket
    end
    def close
      if(@opened && !@closed)
        @closed=true;
        rc=NNCore::LibNanomsg::nn_close(@socket);
        if(rc<0)
          errno=Nanomsg::Lib.new.errorNumber();
          msg=Nanomsg::Lib.new.error();
          raise(SocketError.new(errno,msg))
        end
      end
    end
    def bind(dir)
      rc=NNCore::LibNanomsg::nn_bind(@socket,dir);
      if(rc<0)
        errno=Nanomsg::Lib.new.errorNumber();
        msg=Nanomsg::Lib.new.error();
        raise(SocketError.new(errno,msg))
      end
    end
    def connect(dir)
      rc=NNCore::LibNanomsg::nn_connect(@socket,dir);
      if(rc<0)
        errno=Nanomsg::errorNumber();
        msg=Nanomsg::error();
        raise(SocketError.new(errno,msg))
      end
    end
    def send(data,blocking)
      snd_data=data.pack("U*");
      socket=getNativeSocket()
      flags = blocking ? 0 : NNCore::NN_DONTWAIT
      rc = NNCore::LibNanomsg::nn_send(socket,snd_data.to_s,data.length,flags)
      if(rc<0)
        errno=Nanomsg::errorNumber();
        msg=Nanomsg::error();
        raise(SocketError.new(errno,msg))
      end
      rc
    end
    def recvStr(blocking)
      rcv_buffer = FFI::MemoryPointer.new(1024)
      flags = blocking ? 0 : NNCore::NN_DONTWAIT
      rc = NNCore::LibNanomsg::nn_recv(@socket,rcv_buffer,NNCore::NN_MSG,flags)
      if(rc<0)
        errno=Nanomsg::Lib.new.errorNumber();
        msg=Nanomsg::Lib.new.error();
        raise(SocketError.new(errno,msg))
      end
      data = rcv_buffer.read_string
      data
    end
    def setSendtimeout(milis)
      socket=getNativeSocket()
      NNCore::LibNanomsg::nn_setsockopt(
        socket,NNCore::NN_SOL_SOCKET,NNCore::NN_SNDTIMEO,newSizeT(milis),FFI::MemoryPointer.new(:size_t).size);
    end
    def setRecvtimeout(milis)
      socket=getNativeSocket()
      NNCore::LibNanomsg::nn_setsockopt(
        socket,NNCore::NN_SOL_SOCKET,NNCore::NN_RCVTIMEO,newSizeT(milis),FFI::MemoryPointer.new(:size_t).size);
    end
    def setSizeT(ptr,value)
      if(ptr.size==8)
        ptr.write_long(value)
      else
        ptr.write_int(value)
      end
      ptr
    end
    def newSizeT(value)
      ptr = FFI::MemoryPointer.new(:size_t)
      ptr = setSizeT(ptr,value)
      ptr
    end
  end
end
