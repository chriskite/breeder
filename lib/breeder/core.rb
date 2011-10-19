module Breeder
  class Core
    # the poll interval in seconds
    attr_accessor :interval

    # an instance with spawn? and reap? methods to determine when to spawn and reap
    attr_reader :watcher

    # number of workers to start with
    attr_accessor :initial_workers
    
    def initialize
      @workers = []
      @threads = []
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

    def run
      # start the workers
      self.initial_workers.times { spawn! }

      # catch Ctrl+C and cleanup
      trap('INT') do
        puts 'INTERRUPT caught, killing threads and exiting...'
        @threads.each { |thread| thread.kill }
      end

      # wait for the workers to finish
      @threads.each { |thread| thread.join }
    end

    def create_worker
      raise "No worker factory specified" unless !!@worker_factory
      worker = @worker_factory.call
      unless [:run, :stop!, :stop?].all? { |method| worker.respond_to?(method) }
        raise "object from worker factory doesn't quack like a worker"
      end
      worker
    end

    private

    def spawn!
      worker = create_worker
      @workers << worker
      @threads << Thread.new { worker.run }
    end

    def reap!
      if @threads.size >= 1
        thread = @threads.pop
        worker = @workers.pop
        worker.stop!
        sleep 1
        thread.kill
      end
    end

  end
end
