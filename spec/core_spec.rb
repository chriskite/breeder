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
          watcher = Breeder::Watcher.new
          @core.watcher = watcher
          @core.watcher.should == watcher
        end
      end
    end
  end
end
