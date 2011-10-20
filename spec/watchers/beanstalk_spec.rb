require 'spec_helper'

module Breeder
  module Watchers
    describe Beanstalk do

      before(:each) do
        mock_stalk = mock('beanstalk')
        mock_stalk.stub!(:use)
        mock_stalk.stub!(:jobs).and_return(10)
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
        context 'when there are more than the spawn limit jobs' do
          it 'returns true' do
            pending
          end
        end
        context 'when there are less than the spawn limit jobs' do
          it 'returns false' do
            pending
          end
        end
      end

      describe '#reap?' do
        context 'when there are less than the reap limit jobs' do
          it 'returns true' do
            pending
          end
        end
        context 'when there are more than the reap limit jobs' do
          it 'returns false' do
            pending
          end
        end
      end

    end
  end
end