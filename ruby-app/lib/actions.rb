# TODO
Dir['lib/actions/*.rb'].each do |file|
  require "./#{file}"
end

module Action
end
