# TODO
require_relative 'responses/base.rb'
Dir['lib/responses/*.rb'].each do |file|
  require "./#{file}"
end

module Response
  def self.all
    Response.constants.map do |c|
      const = Response.const_get(c)
      const if const.is_a?(Class)
    end
  end
end
