module Breeder
  class Worker
    attr_accessor :should_stop

    def stop?
      @should_stop
    end

    def stop!
      @should_stop = true
    end

    def run
      until stop?
        do_work
      end
    end

    # User-defined worker should override this
    def do_work
      raise NotImplementedError
    end

  end
end
