module Ddb
  module Userstamp
    module MigrationHelper
      def creator
        Ddb::Userstamp.compatibility_mode ? :created_by : :creator_id
      end
      def updater
        Ddb::Userstamp.compatibility_mode ? :updated_by : :updater_id
      end
      def deleter
        Ddb::Userstamp.compatibility_mode ? :deleted_by : :deleter_id
      end

      module TdInstanceMethods
        include MigrationHelper
        def userstamps(include_deleted_by = false)
          column(creator, :integer)
          column(updater, :integer)
          column(deleter, :integer) if include_deleted_by
        end
      end

      module SsInstanceMethods
        include MigrationHelper
        def add_userstamps(table_name, include_deleted_by = false)
          add_column(table_name, creator, :integer)
          add_column(table_name, updater, :integer)
          add_column(table_name, deleter, :integer) if include_deleted_by
        end

        def remove_userstamps(table_name, include_deleted_by = false)
          remove_column(table_name, creator)
          remove_column(table_name, updater)
          remove_column(table_name, deleter) if include_deleted_by
        end
      end
    end
  end
end

ActiveRecord::ConnectionAdapters::TableDefinition.send(:include, Ddb::Userstamp::MigrationHelper::TdInstanceMethods)

ActiveRecord::ConnectionAdapters::AbstractAdapter.send(:include, Ddb::Userstamp::MigrationHelper::SsInstanceMethods)
