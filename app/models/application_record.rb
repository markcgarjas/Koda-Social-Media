class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  require 'carrierwave/orm/activerecord'
end
