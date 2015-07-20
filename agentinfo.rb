module Framework
  class AgentInfo
    @bindaddr
    @connectaddr
    @ipaddr
    @name
    @nxtaddr
    @servicenxtaddr
    @daemonid
    @myid
    @permanentflag
    @allowremote
    @bundledflag
    @registered
    @timeout
    @numsent
    @numrecv
    @sleepmilis
    @ppid
    @port
    @idle
    attr_accessor :idle
    attr_accessor :bindaddr
    attr_accessor :connectaddr
    attr_accessor :ipaddr
    attr_accessor :name
    attr_accessor :nxtaddr
    attr_accessor :servicenxtaddr
    attr_accessor :daemonid
    attr_accessor :myid
    attr_accessor :permanentflag
    attr_accessor :allowremote
    attr_accessor :bundledflag
    attr_accessor :registered
    attr_accessor :timeout
    attr_accessor :numsent
    attr_accessor :numrecv
    attr_accessor :sleepmilis
    attr_accessor :ppid
    attr_accessor :port
  end
end
