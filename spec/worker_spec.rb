require 'spec_helper'

module Breeder
  describe Worker do

    let(:worker) { Worker.new }

    describe '#stop?' do
      context 'if the worker should stop' do
        it 'returns true' do
          worker.stop!
          worker.stop?.should be_true
        end
      end
      context 'if the worker should not stop' do
        it 'returns false' do
          worker.stop?.should be_false
        end
      end
    end

    describe '#stop!' do
      it 'makes #stop? return true' do
        worker.stop?.should be_false
        worker.stop!
        worker.stop?.should be_true
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
        def do_work
          @value += 1
          stop! if @value >= 3
        end
      end

      it 'does work until told to stop' do
        worker = MyWorker.new
        worker.run
        worker.value.should == 3
      end
    end

  end
end
