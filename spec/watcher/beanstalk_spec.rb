require 'spec_helper'

module Breeder
  module Watcher
    describe Beanstalk do

      before(:each) do
        @mock_stalk = mock('beanstalk')
      end

      describe '#initialize' do
        context 'given a beanstalk connection, a tube, and max_workers' do
          it 'creates a new beanstalk watcher' do
            expect { Breeder::Watcher::Beanstalk.new(@mock_stalk,'tube',8) }.to_not raise_error
          end
        end
        context 'given a beanstalk connection, a tube, and invalid max_workers' do
          it 'raises an error' do
            expect { Breeder::Watcher::Beanstalk.new(@mock_stalk,'tube',-1) }.to raise_error
          end
        end
      end

      describe '#check' do
        context 'when there are more jobs than the last check' do
          it 'returns true' do
            @mock_stalk.
              should_receive(:stats_tube).
              twice. 
              with('tube').
              and_return({'current-jobs-ready' => 10},{'current-jobs-ready' => 12})

            breeder = Breeder::Watcher::Beanstalk.new(@mock_stalk,'tube',8)
            breeder.check(4)
            breeder.check(4).should == :spawn 
          end
        end
        context 'when there are less than 50% fewer jobs than the last check' do
          it 'returns false' do
            @mock_stalk.
              should_receive(:stats_tube).
              twice.
              with('tube').
              and_return({'current-jobs-ready' => 10},{'current-jobs-ready' => 8})

            breeder = Breeder::Watcher::Beanstalk.new(@mock_stalk,'tube',8)
            breeder.check(4)
            breeder.check(4).should be_nil
          end
        end
        context 'when there are 50% fewer jobs than the last check' do
          it 'returns false' do
            @mock_stalk.
              should_receive(:stats_tube).
              twice.
              with('tube').
              and_return({'current-jobs-ready' => 10},{'current-jobs-ready' => 4})

            breeder = Breeder::Watcher::Beanstalk.new(@mock_stalk,'tube',8)
            breeder.check(4)
            breeder.check(4).should == :reap 
          end
        end
      end

      describe '#jobs_ready' do
        it 'returns the number of ready jobs' do
          @mock_stalk.
            should_receive(:stats_tube).
            with('tube').
            and_return({'current-jobs-ready' => 10})

          breeder = Breeder::Watcher::Beanstalk.new(@mock_stalk,'tube',8)
          breeder.jobs_ready.should == 10
        end
      end

    end
  end
end
