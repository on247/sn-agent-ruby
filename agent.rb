require 'date'
module Framework
  class Agent
    def init(agent,args,logger)
      @logger=logger
      @agent=agent
      if(logger==nil)
        logger=STDOUT
      end
      mainLoop(args)
    end
    def addStdFields(data)
      data["allowremote"]=@info.allowremote ? 1:0;
      data["daemonid"]=@info.daemonid;
      data["myid"]=@info.myid;
      if(@info.nxtaddr!=0)
        data["nxtaddr"]=@info.nxtaddr
      end
      if(@info.servicenxtaddr!=0)
        data["serviceNXT"]=@info.servicenxtaddr
      end
      data
    end

    def reply(data)
       bytes=data.unpack("U*")
       bytes.push(0)
       @logger.puts "send:"+data
       @snetsock.send(bytes,true)
       @logger.puts "reply sent"
       @info.numsent+=1
    end
    def mainLoop(args)
      @logger.puts "===============echodemo============="
      @info = Framework::AgentInfo.new
      @info.permanentflag = args[0]
      @info.daemonid = args[1]
      @info.ppid = args[3]
      @info.name=@agent.name
      @info.numsent=0
      @info.numrecv=0
      @info.nxtaddr=0
      @info.servicenxtaddr=0
      @info.myid=rand(2**63)
      @info.idle=0

      tmp=args[2].gsub('\\"',"\"").slice(1..-2)
      params=JSON.parse(tmp);

      nxtbits=Framework::Util.new.emptyToNull(params["NXT"])
      if(nxtbits!=nil)
        @info.nxtaddr=nxtbits
      end

      servicenxt=Framework::Util.new.emptyToNull(params["serviceNXT"])
      if(nxtbits!=nil)
        @info.servicenxtaddr=servicenxt
      end

      @info.ipaddr=Framework::Util.new.emptyToNull(params["ipaddr"])
      if(params.key?("port"))
        @info.port=params["port"]
      end

      @logger.puts "Parent PID is: "+@info.ppid;
      @info.connectaddr="ipc://SuperNET";
      @info.bindaddr="ipc://"+@info.daemonid
      @info.timeout=0

      if(params.key?("timeout"))
        @info.timeout=params["timeout"]
      end

      @info.sleepmilis=100
      if(params.key?("sleepmilis"))
        @info.sleepmilis=params["sleepmilis"]
      end

      @snetsock= Nanomsg::Pipeline::PushSocket.new();
      @snetsock.connect(@info.connectaddr)
      @agentsock= Nanomsg::Bus::BusSocket.new();
      @agentsock.bind(@info.bindaddr)

      @logger.puts ("Connected to :"+@info.connectaddr )
      @logger.puts ("Listening on: "+@info.bindaddr )

      disabled=@agent.register(@info,params);
      @agent.processRegister(@info,params);

      methods=[];
      i=0
      @agent.methods.each{|item|
        if((1<<i)&disabled==0)
          methods.push(item)
        end
        i+=1
      }

      @logger.puts "enabled methods :" + methods.to_s

      pubmethods=@agent.pubmethods;
      authmethods=@agent.authmethods

      registerData={}
      registerData["methods"]=methods
      registerData["pubmethods"]= pubmethods
      registerData["authmethods"]=authmethods
      registerData["plugin"]= "SuperNET"
      registerData["requestType"]="register"
      registerData=addStdFields(registerData);
      registerData["sleepmilis"]=@info.sleepmilis
      registerData["permanentflag"]=@info.permanentflag
      registerData["endpoint"]=@info.bindaddr
      registerData["milis"]=DateTime.now.strftime("%Q").to_i
      registerData["sent"]=@info.numsent
      registerData["recv"]=@info.numrecv
      reply(JSON.generate(registerData).to_s)
      while(true)
        if(@info.idle==0)
          message=nil
          begin
            message=@agentsock.recvStr(false)
            @logger.puts "Recv content: "+message
          rescue Nanomsg::SocketError
          end
          sleep(@info.sleepmilis.to_f/1000)
        end
      end
    end
  end
end
