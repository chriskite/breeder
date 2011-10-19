module Breeder
  class Core
    # the poll interval in seconds
    attr_accessor :interval

    # an instance with spawn? and reap? methods to determine when to spawn and reap
    attr_reader :watcher

    # an instance of Breeder::Worker
    attr_reader :worker
    
    def initialize
      @workers = []
      @threads = []
      self.interval = 5
    end

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
        define_method(:do_work, block)
      end
      @worker = worker
    end

    private

    def spawn!

    end

    def reap!

    end

  end
end
