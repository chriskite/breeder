module Breeder
  class Core
    # the poll interval in seconds (default is 60)
    attr_accessor :interval

    # an instance with spawn? and reap? methods to determine when to spawn and reap
    attr_reader :watcher

    # number of workers to start with
    attr_accessor :initial_workers
    
    def initialize
      self.interval = 6
      self.initial_workers = 4
    end

    def watcher=(watcher)
      unless watcher.respond_to?(:check)
        raise "Watcher must implement 'check' method"
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

      warn "No Watcher specified, will not spawn or reap workers" if @watcher.nil?

      @polling_thread = Thread.new do
        loop do
          if !!@watcher
            decision = @watcher.check(@strategy.num_workers)
            if :spawn == decision
              @strategy.spawn!
              puts "Spawned worker, now running #{@strategy.num_workers} workers"
            elsif :reap == decision
              @strategy.reap!
              puts "Reaped worker, now running #{@strategy.num_workers} workers"
            end
          end
          sleep interval
        end
      end
      @polling_thread.join
    end

  end
end
