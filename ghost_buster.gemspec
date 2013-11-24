Gem::Specification.new do |s|
  s.name        = 'ghost_buster'
  s.version     = '1.0.0'
  s.date        = '2013-11-24'
  s.summary     = "Look for ghost records in a MySQL table"
  s.description = "A utility for all Rails (and other) users who do not rely on db-level foreign keys and thus sometimes break referential integrity. It considers the id attributes to be primary keys and all other attributes ending with _id to be (false) foreign keys. Then it cross references. It might be kind of slow for databases with many records."
  s.authors     = ["Jan Renra Gloser"]
  s.email       = 'jan.renra.gloser@gmail.com'
  s.files       = [
    "lib/ghost_buster.rb",
    "lib/attributes_array.rb",
    "lib/foreign_key.rb",
    "lib/core_ext/string.rb"
  ]
  s.add_runtime_dependency 'awesome_print'
  s.homepage    =
    'https://github.com/renra/ghost-buster-ruby'
  s.license       = 'MIT'
end
