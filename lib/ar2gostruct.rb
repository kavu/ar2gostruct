require 'ar2gostruct/version'

if defined?(Rails)
  require 'ar2gostruct/railtie'
else
  require 'active_support/inflector'
  require 'active_record'
end

module Ar2gostruct
  class Converter
    MODEL_DIR = ENV['model_dir'] || 'app/models'

    TYPE_MAP = {
      'string'     => 'string',
      'text'       => 'string',
      'boolean'    => 'bool',
      'integer(1)' => 'int8',
      'integer(2)' => 'int16',
      'integer(3)' => 'int32',
      'integer(4)' => 'int32',
      'integer(8)' => 'int64',
      'float'      => 'float64',
      'datetime'   => 'time.Time',
      'date'       => 'time.Time'
    }

    class << self
      def convert!
        load_application
        ActiveRecord::Base.descendants.each do |m|
          begin
            convert_to_gostruct(m) if m < ActiveRecord::Base && !m.abstract_class?
          rescue Exception => e
            puts "// Unable to convert #{m}: #{e.message}"
          end
        end
      end

      private
        def load_application
          require "#{Dir.pwd}/config/environment"
          Rails.application.eager_load!
        rescue
        end

        def convert_to_gostruct(klass)
          info = get_schema_info(klass)
          model_file_name = File.join(MODEL_DIR, klass.name.underscore + '.rb')

          puts "// #{model_file_name}\n#{info}"
        end

        def get_schema_info(klass)
          info = "// Table name: #{klass.table_name}\n"
          info << "type #{klass.name.camelize} struct {\n"

          max_size = klass.column_names.collect { |name| name.size }.max + 1

          klass.columns.each do |col|
            tags = []

            # add json tag
            tags << "json:\"#{col.name}\""

            case ENV["orm"]
            when "qbs"
              orm_option = []
              # primary key
              if col.name == klass.primary_key
                orm_option << "pk"
              end
              # not null Constraint
              unless col.null
                orm_option << "notnull"
              end
              # default value
              if col.default
                orm_option << "default:'#{col.default}'"
              end
              if orm_option.present?
                tags << "qbs:\"#{orm_option.join(",")}\""
              end
            end

            col_type = col.type.to_s
            case col_type
            when "integer"
              type = TYPE_MAP["integer(#{col.limit})"] || "int32"
              type = "u#{col_type}" if col.sql_type.match("unsigned").present?
            else
              type = TYPE_MAP[col_type] || "string"
            end

            info << sprintf("\t%-#{max_size}.#{max_size}s%-15.15s`%s`\n", col.name.camelize, type, tags.join(" "))
          end

          klass.reflections.values.each do |assoc|
            name = assoc.name.to_s
            pluralized_name = name.pluralize
            singularized_name = name.singularize

            case assoc.macro
            when :has_many
              name = pluralized_name
              type = "[]#{singularized_name.camelize}"
            when :belongs_to, :has_one
              name = type = singularized_name
            end

            if name && type
              info << sprintf("\t%-#{max_size}.#{max_size}s%-15.15s`%s`\n", name.camelize, type.camelize, "json:\"#{assoc.name}\"")
            end
          end

          info << "}\n\n"
        end
    end
  end
end
