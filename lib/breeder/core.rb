module Breeder
  class Core
    attr_reader :watcher
    
    def watcher=(watcher)
      unless watcher.respond_to?(:spawn?) && watcher.respond_to?(:reap?)
        raise "Watcher must implement spawn? and reap?"
      end
      
      @watcher = watcher
    end

  end
end
