module Breeder
  module BreedingStrategy
    class Forks 

      def initialize(worker_factory, initial_workers)
        @children = []
        @worker_factory = worker_factory
        @initial_workers = initial_workers
      end

      def num_workers
        @children.size
      end

      def start!
        @initial_workers.times { spawn! }
      end

      def stop!
        @children.size.times { reap! }
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
        t = Thread.new do
          if pid = Process.fork
            #parent
            @children << pid
          else
            worker = create_worker
            #child
            trap('HUP') do
              worker.stop!
            end
            trap('INT', 'DEFAULT')
            worker.run
            Process.exit
          end
        end
        t.join
      end

      def reap!
        if @children.size > 1
          pid = @children.pop
          Process.kill('HUP', pid)
          sleep 1
          Process.kill(9, pid)
        end
      end

    end
  end
end

