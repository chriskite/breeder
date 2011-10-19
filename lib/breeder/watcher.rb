module Breeder

  # A watcher has a spawn? and reap? method that indicate when to 
  # spawn and reap more threads
  class Watcher

    def spawn?
      raise NotImplementedError
    end

    def reap?
      raise NotImplementedError
    end

  end
end
