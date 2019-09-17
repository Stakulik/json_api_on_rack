require "securerandom"

class UsersProcessor
  def initialize(args)
    @request = args[:request]
    @payload = args[:payload]
    @storage = args[:storage]
  end

  def process
    return create if request.post? && path_info.empty?
    return show if request.get? && !path_info.empty?
    return index if request.get? && path_info.empty?
    wrap_error :not_found
  end

  private

  attr_reader :request, :payload, :storage

  def create
    email = payload["email"]&.strip

    error = email_validation_error(email)

    if error.nil?
      collection[uuid] = { email: email }
      emails_index << email

      wrap_data(id: uuid, email: email)
    else
      wrap_error error
    end
  end

  def email_validation_error(email)
    if email.nil?
      :email_missing
    elsif !/\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i.match?(email)
      :wrong_email_format
    elsif emails_index.include?(email)
      :email_already_exists
    end 
  end

  def emails_index
    storage.emails_index
  end

  def path_info
    @path_info ||= request.path_info.sub("/", "").downcase
  end

  def show
    user_data = collection[path_info]

    if user_data.nil?
      wrap_error :not_found
    else
      wrap_data(id: path_info, email: user_data[:email])
    end
  end

  def index
    wrap_data collection.map { |uuid, user_attrs| { id: uuid }.merge(user_attrs) }
  end

  def wrap_data(data)
    { data: data }
  end

  def wrap_error(error_code)
    { error_code: error_code }
  end

  def collection
    storage.collection
  end

  def uuid
    @uuid ||= SecureRandom.uuid
  end
end
