module Framework
  class Util
    def emptyToNull(str)
      value=(str == nil || str== '') ? nil : str;
      value
    end
  end
end
