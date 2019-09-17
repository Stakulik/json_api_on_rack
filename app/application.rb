require_relative "users_processor"
require_relative "users_storage"
require_relative "responder"

class Application
  def call(environment)
    @env = environment

    Responder.new(response).respond
  end

  private

  attr_reader :env

  def response
    processor_class.new(request: request, payload: payload, storage: send(storage)).process
  end

  def request
    Rack::Request.new(env)
  end

  def payload
    JSON.parse request.body.read if request.post?
  end

  def processor_class
    Object.const_get("#{type.capitalize}Processor")
  end

  def storage
    "#{type}_storage"
  end

  def users_storage
    @users_storage ||= UsersStorage.new
  end

  def type
    request.script_name.sub("/", "")
  end
end
