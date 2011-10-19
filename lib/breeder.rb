require 'rubygems'
require 'breeder/core'

module Breeder 
  # Create a Breeder::Core and take a block to configure it
  def self.create
    core = Breeder::Core.new
    yield core if block_given?
    core
  end

  def self.breed(&block)
    core = Breeder::Core.new
    yield core
    core.run
  end
end
