module Breeder
  module Watchers
    class Beanstalk

      def initialize(host, tube, spawn, reap)
        raise 'Invalid limits; Expected spawn >= reap' if spawn < reap
        @beanstalk = ::Beanstalk::Pool.new(host)
        @beanstalk.use(tube)
        @tube, @spawn, @reap = tube, spawn, reap
      end

      def spawn?
        @spawn < jobs_ready
      end

      def reap?
        @reap > jobs_ready
      end

      def jobs_ready
        @beanstalk.stats_tube(@tube)['current-jobs-ready']
      end

    end
  end
end