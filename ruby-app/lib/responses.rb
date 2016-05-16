# TODO
require_relative 'responses/base.rb'
Dir['lib/responses/*.rb'].each do |file|
  require "./#{file}"
end

module Response
end
