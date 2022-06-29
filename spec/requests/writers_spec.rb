require 'rails_helper'

RSpec.describe "Writers", type: :request do
    let(:admin) { FactoryBot.create(:user, username: 'user', email: 'user@gmail.com', password: 'password', password_confirmation: 'password', is_admin: true) }

    let(:writer) { FactoryBot.create(:writer, name: 'Andrea Hirata') }

    def json
        JSON.parse(response.body)
    end

    describe 'GET /writers' do
        it 'reponds invalid request without JWT' do
          get '/writers'
          expect(response).to have_http_status(401)
          expect(response.body).to match("\"errors\":\"Nil JSON web token")
        end
    
        it 'responds JSON with JWT' do
          post "/auth/login", params: {email: admin.email, password: 'password'}
          token = json["token"]
          get "/writers", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
    
          expect(response).to have_http_status(200)
        end
    end

    describe 'GET /writers/{id}' do
        it 'responds JSON with JWT' do
          post "/auth/login", params: {email: admin.email, password: 'password'}
          token = json["token"]
          get "/writers/#{writer.id}", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
    
          expect(response).to have_http_status(200)
        end
    end

    describe "DELETE /writers/{id}" do
        it 'responds JSON with JWT' do
          post "/auth/login", params: {email: admin.email, password: 'password'}
          token = json["token"]
          delete "/writers/#{writer.id}", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
          expect(response).to have_http_status(200)
        end
    end
end
