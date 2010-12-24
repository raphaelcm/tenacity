require 'couchrest_extended_document'

class CouchRestRadio < CouchRest::ExtendedDocument
  include Tenacity
  use_database COUCH_DB

  t_belongs_to :mongo_mapper_dashboard
  t_has_many :mongo_mapper_buttons
end
