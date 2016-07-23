
require 'wikisnakker'

desc "Refresh the information in the country meta.json"
task :refresh_country_meta do
  l_json = json_load('meta.json')
  c_json = json_load('../meta.json') rescue {}

  abort "No wikidata!" unless l_json[:wikidata]
  legislature = Wikisnakker::Item.find(l_json[:wikidata])
  jurisdiction = (legislature.P1001 || legislature.P131 || legislature.P17 || binding.pry).value

  data = {
    name: jurisdiction.label('en'),
    iso_code: jurisdiction.P297,
    wikidata: jurisdiction.id,
  }.merge(c_json)
  
  puts JSON.pretty_generate(data)

  File.write('../meta.json', JSON.pretty_generate(c_json))
end

