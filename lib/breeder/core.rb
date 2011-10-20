module Breeder
  class Core
    # the poll interval in seconds
    attr_accessor :interval

    # an instance with spawn? and reap? methods to determine when to spawn and reap
    attr_reader :watcher

    # number of workers to start with
    attr_accessor :initial_workers
    
    def initialize
      self.interval = 5
      self.initial_workers = 4
    end

    def watcher=(watcher)
      unless watcher.respond_to?(:spawn?) && watcher.respond_to?(:reap?)
        raise "Watcher must implement spawn? and reap?"
      end
      
      @watcher = watcher
    end

    def worker_factory(&block)
      raise "No block supplied to worker_factory" unless !!block
      @worker_factory = block
    end

    def task(&block)
      raise ArgumentError("No block supplied") if block.nil?
      worker = Breeder::Worker.new
      worker.__metaclass__.class_eval do
        define_method(:do_work, block)
      end
      worker_factory { worker }
    end

    def init_strategy
      @strategy = Breeder::BreedingStrategy::Forks.new(@worker_factory, initial_workers)

      # catch Ctrl+C and cleanup
      trap('INT') do
        puts 'INTERRUPT caught, killing workers and exiting...'
        @strategy.stop!
        @polling_thread.kill rescue nil
      end
    end

    def run
      # setup the breeding strategy
      init_strategy

      # start the workers
      @strategy.start!

      @polling_thread = Thread.new do
        # TODO polling 
        loop do
          sleep interval
        end
      end
      @polling_thread.join
    end

  end
end
