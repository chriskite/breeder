require 'spec_helper'

describe Breeder do
  before(:each) do
    @mock_core = mock('core')
    Breeder::Core.stub!(:new).and_return(@mock_core)
  end

  describe '.create' do
    it 'returns a Breeder::Core' do
      Breeder.create.should be_a(Breeder::Core)
    end

    it 'takes a block to configure the Core' do
      @mock_core.should_receive(:interval=).with(5)
      breeder = Breeder.create do |core|
        core.interval = 5 
      end
      breeder.should == @mock_core
    end
  end

  describe '.breed' do
    it 'takes a block to configure the Core' do
      @mock_core.should_receive(:interval=).with(5)
      Breeder.breed do |core|
        core.interval = 5
      end
    end

    it 'runs the Core after configuration' do
      @mock_core.should_receive(:interval=).with(5).ordered
      @mock_core.should_receive(:run).ordered
      Breeder.breed do |core|
        core.interval = 5
      end
    end
  end
end
