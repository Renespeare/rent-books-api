require 'rails_helper'

RSpec.describe "Borrows", type: :request do
    let(:user) { FactoryBot.create(:user, username: 'user', email: 'user@gmail.com', password: 'password', password_confirmation: 'password') }

    let(:book) { FactoryBot.create(:book, title: 'Laskar Pelangi') }
    let(:borrow) { FactoryBot.create(:borrow, user_id: user.id, book_id: book.id) }

    def json
        JSON.parse(response.body)
    end

    describe 'GET /borrows' do
        it 'reponds invalid request without JWT' do
          get '/borrows'
          expect(response).to have_http_status(401)
          expect(response.body).to match("\"errors\":\"Nil JSON web token")
        end
    
        it 'responds JSON with JWT' do
          post "/auth/login", params: {email: user.email, password: 'password'}
          token = json["token"]
          get "/borrows", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
    
          expect(response).to have_http_status(200)
        end
    end

    describe 'GET /borrows/{id}' do
        it 'responds JSON with JWT' do
          post "/auth/login", params: {email: user.email, password: 'password'}
          token = json["token"]
          get "/borrows/#{borrow.id}", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
    
          expect(response).to have_http_status(200)
        end
    end

    describe "DELETE /borrows/{id}" do
        it 'responds JSON with JWT' do
          post "/auth/login", params: {email: user.email, password: 'password'}
          token = json["token"]
          delete "/borrows/#{borrow.id}", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
          expect(response).to have_http_status(200)
        end
    end
end
