require 'spec_helper'

module Breeder
  module Watchers
    describe Beanstalk do

      before(:each) do
        mock_stalk = mock('beanstalk')
        mock_stalk.stub!(:use)
        mock_stalk.stub!(:stats_tube).and_return({'current-jobs-ready' => 10})
        ::Beanstalk::Pool.stub!(:new).and_return(mock_stalk)
      end

      after(:all) do
        Beanstalk::Pool.unstub!(:new)
      end

      describe '#initialize' do
        context 'given a beanstalk connection, a tube, and valid reap and spawn limits' do
          it 'creates a new beanstalk watcher' do
            expect { Breeder::Watchers::Beanstalk.new('test','tube',10,3) }.to_not raise_error
          end
        end
        context 'given a beanstalk connection, a tube, and invalid reap and spawn limits' do
          it 'raises an error' do
            expect { Breeder::Watchers::Beanstalk.new('test','tube',3,10) }.to raise_error
          end
        end
      end

      describe '#spawn?' do
        context 'when there are more jobs than the spawn limit' do
          it 'returns true' do
            breeder = Breeder::Watchers::Beanstalk.new('test','tube',5,4)
            breeder.spawn?.should be_true
          end
        end
        context 'when there are less jobs than the spawn limit jobs' do
          it 'returns false' do
            breeder = Breeder::Watchers::Beanstalk.new('test','tube',20,4)
            breeder.spawn?.should be_false
          end
        end
      end

      describe '#reap?' do
        context 'when there are less jobs than the reap limit' do
          it 'returns true' do
            breeder = Breeder::Watchers::Beanstalk.new('test','tube',20,15)
            breeder.reap?.should be_true
          end
        end
        context 'when there are more jobs than the reap limit' do
          it 'returns false' do
            breeder = Breeder::Watchers::Beanstalk.new('test','tube',10,5)
            breeder.reap?.should be_false
          end
        end
      end

      describe '#jobs_ready' do
        it 'returns the number of ready jobs' do
          breeder = Breeder::Watchers::Beanstalk.new('test','tube',5,4)
          breeder.jobs_ready.should == 10
        end
      end

    end
  end
end