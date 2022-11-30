# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  RESERVE_TABLES = ['schema_migrations', 'ar_internal_metadata']
end
