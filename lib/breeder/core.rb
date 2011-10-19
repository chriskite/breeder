module Breeder
  class Core
    attr_reader :watcher
    attr_reader :worker
    
    def watcher=(watcher)
      unless watcher.respond_to?(:spawn?) && watcher.respond_to?(:reap?)
        raise "Watcher must implement spawn? and reap?"
      end
      
      @watcher = watcher
    end

    def worker=(worker)
      unless worker.is_a?(Breeder::Worker)
        raise "Worker must inherit from Breeder::Worker"
      end
      
      @worker = worker
    end

    def task(&block)
      raise ArgumentError("No block supplied") if block.nil?
      worker = Breeder::Worker.new
      worker.__metaclass__.class_eval do
        def do_work
          block.call
        end
      end
    end

  end
end
