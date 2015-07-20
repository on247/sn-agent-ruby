module Framework
  class ProcessUtils
    def OsGetPpid
      Process::ppid
    end
    def OsPingPid(pid)
      Process.Kill(0,pid)
    end
    def RandomBytes(size)
      Random.new.bytes(size).bytes
    end
  end
end
