require 'rubygems'
require 'metaclass'
require 'beanstalk-client'
require 'breeder/breeding_strategy'
require 'breeder/core'
require 'breeder/watcher'
require 'breeder/worker'

module Breeder 
  # Create a Breeder::Core and take a block to configure it
  def self.create
    core = Breeder::Core.new
    yield core if block_given?
    core
  end

  # Configure and run a Breeder::Core
  def self.breed(&block)
    core = Breeder::Core.new
    yield core
    core.run
  end
end
