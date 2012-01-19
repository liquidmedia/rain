module Rain
  class Cloud < Drop
    def to_s
      name
    end
    alias :uri :to_s
  end
end