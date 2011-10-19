module Breeder
  class Worker
    attr_accessor :should_stop

    def stop?
      @should_stop
    end

    def stop!
      #TODO
    end

    def request_stop
      @should_stop = true
    end

    # User-defined worker should override this
    def do_work
      raise NotImplementedError
    end

    def run
      until stop?
        do_work
      end
      stop!
    end

  end
end
