require 'rails_helper'

RSpec.describe "Writerships", type: :request do
    let(:admin) { FactoryBot.create(:user, username: 'user', email: 'user@gmail.com', password: 'password', password_confirmation: 'password', is_admin: true) }

    let(:writer) { FactoryBot.create(:writer, name: 'Andrea Hirata') }
    let(:book) { FactoryBot.create(:book, title: 'Laskar Pelangi') }
    let(:writership) { FactoryBot.create(:writership, book_id: book.id, writer_id: writer.id) }

    def json
        JSON.parse(response.body)
    end

    describe 'GET /writerships' do
        it 'reponds invalid request without JWT' do
          get '/writerships'
          expect(response).to have_http_status(401)
          expect(response.body).to match("\"errors\":\"Nil JSON web token")
        end
    
        it 'responds JSON with JWT' do
          post "/auth/login", params: {email: admin.email, password: 'password'}
          token = json["token"]
          get "/writerships", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
    
          expect(response).to have_http_status(200)
        end
    end

    describe 'GET /writerships/{id}' do
        it 'responds JSON with JWT' do
          post "/auth/login", params: {email: admin.email, password: 'password'}
          token = json["token"]
          get "/writerships/#{writership.id}", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
    
          expect(response).to have_http_status(200)
        end
    end

    describe "DELETE /writerships/{id}" do
        it 'responds JSON with JWT' do
          post "/auth/login", params: {email: admin.email, password: 'password'}
          token = json["token"]
          delete "/writers/#{writership.id}", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
          expect(response).to have_http_status(200)
        end
    end
end
