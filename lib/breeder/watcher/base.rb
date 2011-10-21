module Breeder
  class Base 

    # Check whether to spawn, reap, or do nothing
    # Returns :spawn or :reap or nil
    def check(num_workers)
      raise NotImplementedError
    end

  end
end
