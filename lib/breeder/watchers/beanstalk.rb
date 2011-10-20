module Breeder
  module Watchers
    class Beanstalk

      def initialize(host, tube, spawn, reap)
        raise 'Invalid limits; Expected spawn >= reap' if spawn < reap
        @beanstalk = ::Beanstalk::Pool.new(host)
        @beanstalk.use(tube)
        @spawn, @reap = spawn, reap
      end

      def spawn?
        #TODO
      end

      def reap?
        #TODO
      end

    end
  end
end