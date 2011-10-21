module Breeder
  module Watcher
    class Beanstalk < Base

      def initialize(client, tube, max_workers)
        raise "max_workers must be at least 1" if max_workers < 1
        @client, @tube, @max_workers = client, tube, max_workers
        @last_check = nil
      end

      def check(num_workers)
        num = jobs_ready
        if !!@last_check && num > @last_check && num_workers <= @max_workers
          decision = :spawn
        elsif !!@last_check && num < 0.5 * @last_check
          decision = :reap
        else
          decision = nil
        end
        @last_check = num
        decision
      end

      def jobs_ready
        @client.stats_tube(@tube)['current-jobs-ready']
      end

    end
  end
end
