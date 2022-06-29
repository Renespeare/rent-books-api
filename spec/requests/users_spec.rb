require 'rails_helper'

RSpec.describe "Users", type: :request do
  let(:user) { FactoryBot.create(:user, username: 'user', email: 'user@gmail.com', password: 'password', password_confirmation: 'password') }

  def json
    JSON.parse(response.body)
  end

  describe 'GET /users' do
    it 'reponds invalid request without JWT' do
      get '/books'
      expect(response).to have_http_status(401)
      expect(response.body).to match("\"errors\":\"Nil JSON web token")
    end

    it 'responds JSON with JWT' do
      post "/auth/login", params: {email: user.email, password: 'password'}
      token = json["token"]
      get "/users", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}

      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /users/{username}' do
    it 'responds JSON with JWT' do
      post "/auth/login", params: {email: user.email, password: 'password'}
      token = json["token"]
      get "/users/#{user.username}", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}

      expect(response).to have_http_status(200)
    end
  end

  describe "DELETE /users/{username}" do
    it 'responds JSON with JWT' do
      post "/auth/login", params: {email: user.email, password: 'password'}
      token = json["token"]
      delete "/users/#{user.username}", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
      expect(response).to have_http_status(200)
    end
  end

end
