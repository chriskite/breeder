module Breeder
  module BreedingStrategy
    class Threads

      def initialize(worker_factory, initial_workers)
        @threads = []
        @workers = []
        @worker_factory = worker_factory
        @initial_workers = initial_workers
      end

      def num_workers
        @threads.size
      end

      def start!
        @initial_workers.times { spawn! }
      end

      def stop!
        @workers.size.times { reap! }
      end

      def create_worker
        raise "No worker factory specified" unless !!@worker_factory
        worker = @worker_factory.call
        unless [:run, :stop!, :stop?].all? { |method| worker.respond_to?(method) }
          raise "object from worker factory doesn't quack like a worker"
        end
        worker
      end

      def spawn!
        worker = create_worker
        @workers << worker
        @threads << Thread.new { worker.run }
      end

      def reap!
        if !@workers.empty?
          thread = @threads.pop
          worker = @workers.pop
          worker.stop!
          sleep 1
          thread.kill
        end
      end

    end
  end
end
