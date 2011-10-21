require 'spec_helper'

module Breeder
  describe Core do
    before(:each) do
      @core = Breeder.create
    end

    describe '#watcher=' do
      context 'when the argument is not a valid watcher' do
        it 'raises an exception' do
          lambda { @core.watcher = 42 }.should raise_error
        end
      end

      context 'when the argument is a valid watcher' do
        it 'sets the watcher' do
          watcher = Breeder::Watcher::Beanstalk.new(mock('stalk'), 'tube', 8)
          @core.watcher = watcher
          @core.watcher.should == watcher
        end
      end
    end

    describe '#worker_factory' do
      it 'sets the worker factory' do
        pending
      end
    end

    describe '#task' do
      context 'when no block is supplied' do
        it 'raises an error' do
          lambda { @core.task }.should raise_error
        end
      end

      context 'when a block of work is supplied' do
        it 'creates a worker with the block as its workload' do
          pending 'no create_watcher method'
          task_done = false
          @core.task { task_done = true }
          @core.create_worker.do_work
          task_done.should == true
        end
      end
    end
  end
end
