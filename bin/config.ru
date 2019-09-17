require "bundler/setup"
require "json"

require "./app/application"
require "./app/responder"

map "/users" do
  run Application.new
end

map "/" do
  run -> (env) { [404, { "Content-Type" => "application/json" }, [{ errors: { code: :not_found } }.to_json] ] }
end
