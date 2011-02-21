module API
  module Index
    class Memory < Base
      
      # Injects the necessary options & configurations for
      # a memory index backend.
      #
      def initialize name, source, options = {}
        options[:indexing_bundle_class] ||= Indexing::Bundle::Memory
        
        super name, source, options
      end
      
    end
  end
end