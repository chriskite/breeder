module Breeder

  # A watcher has a spawn? and reap? method that indicate when to 
  # spawn and reap more threads
  class Watcher

    def spawn?(num_workers)
      raise NotImplementedError
    end

    def reap?(num_workers)
      raise NotImplementedError
    end

  end
end
