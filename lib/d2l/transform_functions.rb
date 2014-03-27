# require all the possible functions
Dir[File.dirname(__FILE__) + '/transform_functions/*.rb'].each {|file| require file }

module D2L
  module TransformFunctions
    # Find the correct transform function.
    # Functions can be added inside transform_functions directory
    def self.find_for(dataclip)
      function = available_functions.each do |f|
        function = TransformFunctions.const_get(f).new
        return function if function.accepts?(dataclip)
      end
      # Default return function
      TransformFunctions::Default.new
    end

    def self.available_functions
      TransformFunctions.constants.select do |c|
        Class === TransformFunctions.const_get(c) && ![:Default, :Base].include?(c)
      end
    end
  end
end
