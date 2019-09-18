require "bundler/setup"
require "rack/test"
require "json"

require "./app/application"

describe "requests" do
  include Rack::Test::Methods

  let(:headers) do
    {
      "Accept" => "application/json",
      "Content-Type" => "application/json"
    }
  end

  let(:new_user_params_1) { { "email": "john@example.com" } }
  let(:new_user_params_2) { { "email": "doe@sample.us" } }

  def app
    Application.new
  end

  def make_request(url, params = {}, method = :get)
    send(method, url, params.to_json, headers)
  end

  def json_response_body(body)
    JSON.parse(body)
  end

  describe "/users" do
    it do
      allow_any_instance_of(Rack::Request).to receive(:script_name).and_return("/users")
      allow_any_instance_of(Rack::Request).to receive(:path_info).and_return("/")

      # проверяем, что коллекция пуста
      response = make_request("/users")

      aggregate_failures "response" do
        expect(json_response_body(response.body)).to eq({ "data" => [] })
        expect(response.status).to eq(200)
      end

      # добавляем 1 юзера
      response = make_request("/users", new_user_params_1, :post)
      user_data_1 = json_response_body(response.body)["data"]

      aggregate_failures "response" do
        expect(user_data_1["email"]).to eq("john@example.com")
        expect(user_data_1["id"]).not_to be_empty
        expect(response.status).to eq(201)
      end

      # добавляем 2 юзера
      response = make_request("/users", new_user_params_2, :post)
      user_data_2 = json_response_body(response.body)["data"]

      # проверяем коллекцию
      response = make_request("/users")
      users_data = json_response_body(response.body)["data"]

      aggregate_failures "response" do
        expect(users_data.first).to eq(user_data_1)
        expect(users_data.last).to eq(user_data_2)

        expect(response.status).to eq(200)
      end

      # проверяем 1 юзера
      allow_any_instance_of(Rack::Request).to receive(:path_info).and_return("/#{user_data_1['id']}")

      response = make_request("/users/#{user_data_1['id']}")

      aggregate_failures "response" do
        expect(json_response_body(response.body)["data"]).to eq(user_data_1)
        expect(response.status).to eq(200)
      end
    end
  end

  describe "other routes" do
    # проверяем, что остальные пути отдают 404
    let(:response_404) do
      {
        "errors" => {
          "code" => "not_found"
        }
      }
    end

    it do
      aggregate_failures "response" do
        expect(json_response_body make_request("/users/123").body).to eq(response_404)
        expect(json_response_body make_request("/").body).to eq(response_404)
        expect(json_response_body make_request("/abc").body).to eq(response_404)
        expect(json_response_body make_request("/user").body).to eq(response_404)
      end
    end
  end
end
