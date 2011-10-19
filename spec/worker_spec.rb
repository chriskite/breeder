require 'spec_helper'

module Breeder
  describe Worker do

    let(:worker) { Worker.new }

    describe '#stop?' do
      context 'if the worker should stop' do
        it 'returns true' do
          worker.should_stop = true
          worker.stop?.should be_true
        end
      end
      context 'if the worker should not stop' do
        it 'returns false' do
          worker.stop?.should be_false
          worker.should_stop = false
          worker.stop?.should be_false
        end
      end
    end

    describe '#request_stop' do
      it 'sets @should_stop' do
        worker.should_stop.should be_false
        worker.request_stop
        worker.should_stop.should be_true
      end
    end

    describe '#stop!' do
      it 'stops the worker cleanly' do
        pending
      end
    end

    describe '#do_work' do
      context 'when the user has not overridden it' do
        it 'raises an error' do
          expect { worker.do_work }.to raise_error
        end
      end
    end

    describe '#run' do

      class MyWorker < Worker
        attr_reader :value
        def initialize
          @value = 0
        end
        def stop!
          'stopped'
        end
        def do_work
          @value += 1
          request_stop if @value >= 3
        end
      end

      it 'does work until told to stop' do
        worker = MyWorker.new
        worker.run.should == 'stopped'
        worker.value.should == 3
      end
      context 'when the user has specified a naptime' do
        it 'takes the specified naptime in between loops' do
          worker = MyWorker.new
          now = Time.now()
          worker.run(1).should == 'stopped'
          worker.value.should == 3
          and_then = Time.now
          (and_then - now).should >= 3
        end
      end
    end

  end
end
