module D2L
  module Dataclips
    class Result < Struct.new(:fields, :values)
      def self.from(json_response)
        check_response_validity!(json_response)
        new(json_response['fields'], parse_values(json_response))
      end

      def self.parse_values(json_response)
        struct_fields = json_response['fields'].map(&:to_sym)
        struct = Struct.new(*struct_fields)
        json_response['values'].map do |json_value|
          if json_value.size != struct_fields.size
            message = "value '#{json_value}' has not the right fields #{struct_fields}"
            raise(Error, message)
          end
          struct.new(*json_value)
        end
      end

      def self.check_response_validity!(json_response)
        check_field_is_array!(json_response['fields'], 'fields')
        check_field_is_array!(json_response['values'], 'values')
        raise(Error, "'fields' is empty") if json_response['fields'].size == 0
      end

      def self.check_field_is_array!(field, name)
        raise(Error, "'#{name}' is missing") unless field
        raise(Error, "'#{name}' is not an array") unless field.is_a? Array
      end

      def empty?
        values.size == 0
      end

      def matching_fields(regexp)
        fields.select { |f| f =~ regexp }
      end

      def has_field?(name)
        if name.is_a? Regexp
          fields.any? { |f| f =~ name }
        else
          fields.include? name.to_s
        end
      end
    end

    class Error < StandardError; end
  end
end
