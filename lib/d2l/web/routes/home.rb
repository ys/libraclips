module D2L
  module Web
    module Routes
      class Home < Sinatra::Application
        get '/' do
          json_schema.to_json
        end

        def json_schema
          {
            "$schema" => "http://json-schema.org/draft-04/schema#",
            "title" => "Measurement",
            "description" => "A dataclips measurement run every x seconds",
            "type" => "object",
            "properties" => {
              "id" => {
                "description" => "measurement uuid",
                "type" => "string",
                "readOnly" => "true"
              },
              "dataclip_reference" => {
                "description" => "The reference to the dataclips (dataclips url/id)",
                "type" => "string"
              },
              "librato_base_name" => {
                "description" => "The prefix for each librato metrics that will be computed",
                "type" => "string"
              },
              "run_interval" => {
                "description" => "The minimum time after which dataclip measurement is outdated",
                "type" => "integer"
              },
              "librato_source" => {
                "description" => "The source for librato metric",
                "type" => "string"
              },
              "run_at" => {
                "description" => "Last time it was run",
                "type" => "time",
                "readOnly" => "true"
              },
            },
            "required" => ["dataclip_reference", "librato_base_name"],
            "links" => [
              {
                "description" => "Get all measurements tracked actually.",
                "href" => "/measurements",
                "method" => "GET",
                "rel" => "list",
                "title" => "Measurements"
              },
              {
                "description" => "Create measurement.",
                "href" => "/measurements",
                "method" => "POST",
                "rel" => "create",
                "schema" => {
                  "properties" => {
                    "dataclip_reference" => {
                      "$ref" => "#/properties/dataclip_reference"
                    },
                    "librato_base_name" => {
                      "$ref" => "#/properties/librato_base_name"
                    },
                    "run_interval" => {
                      "$ref" => "#/properties/run_interval"
                    },
                    "librato_source" => {
                      "$ref" => "#/properties/librato_source"
                    }
                  }
                },
                "title" => "Create"
              },
              {
                "description" => "Update measurement.",
                "href" => "/measurements/{id}",
                "method" => "PATCH",
                "rel" => "update",
                "schema" => {
                  "properties" => {
                    "dataclip_reference" => {
                      "$ref" => "#/properties/dataclip_reference"
                    },
                    "librato_base_name" => {
                      "$ref" => "#/properties/librato_base_name"
                    },
                    "run_interval" => {
                      "$ref" => "#/properties/run_interval"
                    },
                    "librato_source" => {
                      "$ref" => "#/properties/librato_source"
                    }
                  }
                },
                "title" => "Update"
              }]
          }
        end
      end
    end
  end
end

