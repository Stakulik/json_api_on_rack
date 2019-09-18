class Responder
  def initialize(args)
    @data = args.slice(:data)
    @success_code = args[:success_code]
    @error_code = args[:error_code]
  end

  def respond
    error_code.nil? ? send(success_code, data) : send(error_code)
  end

  private

  attr_reader :data, :success_code, :error_code

  def ok(data)
    [200, { "Content-Type" => "application/json" }, [data.to_json]]
  end

  def created(data)
    [201, { "Content-Type" => "application/json" }, [data.to_json]]
  end

  def unprocessable_entity
    [422, { "Content-Type" => "application/json" }, [{ errors: { code: error_code } }.to_json]]
  end

  def not_found
    [404, { "Content-Type" => "application/json" }, [{ errors: { code: error_code } }.to_json]]
  end

  alias_method :email_missing, :unprocessable_entity
  alias_method :email_already_exists, :unprocessable_entity
  alias_method :wrong_email_format, :unprocessable_entity
end
