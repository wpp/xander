# TODO
Dir['lib/responses/*.rb'].each do |file|
  require "./#{file}"
end

module Response
end
