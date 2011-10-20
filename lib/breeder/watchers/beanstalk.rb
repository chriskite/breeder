module Breeder
  module Watchers
    class Beanstalk < Watcher

      def initialize(conn, tube, spawn, reap)
        raise 'Invalid limits; Expected spawn >= reap' if spawn < reap
        @conn, @tube, @spawn, @reap = conn, tube, spawn, reap
      end

      def spawn?
        @spawn < jobs_ready
      end

      def reap?
        @reap > jobs_ready
      end

      def jobs_ready
        @conn.stats_tube(@tube)['current-jobs-ready']
      end

    end
  end
end