require 'rails_admin/config/fields/types/string'

module RailsAdmin
  module Config
    module Fields
      module Types
        class BsonObjectId < RailsAdmin::Config::Fields::Types::String
          # Register field type for the type loader
          RailsAdmin::Config::Fields::Types.register(self)

          register_instance_option :label do
            label = ((@label ||= {})[::I18n.locale] ||= abstract_model.model.human_attribute_name name)
            label = 'Id' if label == ''
            label
          end

          def generic_help
            'BSON::ObjectId'
          end

          register_instance_option :read_only do
            true
          end

          register_instance_option :sort_reverse? do
            serial?
          end

          def parse_value(value)
            value.present?? abstract_model.object_id_from_string(value) : nil
          rescue => e
            unless ['BSON::InvalidObjectId', 'Moped::Errors::InvalidObjectId'].include? e.class.to_s
              fail e
            end
          end

          def parse_input(params)
            params[name] = parse_value(params[name]) if params[name].is_a?(::String)
          end
        end
      end
    end
  end
end
