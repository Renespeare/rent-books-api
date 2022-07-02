require 'rails_helper'

RSpec.describe "Reviews", type: :request do
  let(:user) { FactoryBot.create(:user, username: 'user', email: 'user@gmail.com', password: 'password', password_confirmation: 'password', is_admin: false) }

  let(:book) { FactoryBot.create(:book, title: 'Laskar Pelangi') }
  let(:review) { FactoryBot.create(:review, user_id: user.id, book_id: book.id, star: 5, comment: 'Great Book') }

  def json
      JSON.parse(response.body)
  end

  describe 'GET /reviews' do
      it 'reponds invalid request without JWT' do
        get '/reviews'
        expect(response).to have_http_status(401)
        expect(response.body).to match("\"errors\":\"Nil JSON web token")
      end
  
      it 'responds JSON with JWT' do
        post "/auth/login", params: {email: user.email, password: 'password'}
        token = json["token"]
        get "/reviews", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
  
        expect(response).to have_http_status(200)
      end
  end

  describe 'GET /reviews/{id}' do
      it 'responds JSON with JWT' do
        post "/auth/login", params: {email: user.email, password: 'password'}
        token = json["token"]
        get "/reviews/#{review.id}", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
  
        expect(response).to have_http_status(200)
      end
  end

  describe "DELETE /reviews/{id}" do
      it 'responds JSON with JWT' do
        post "/auth/login", params: {email: user.email, password: 'password'}
        token = json["token"]
        delete "/reviews/#{review.id}", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
        expect(response).to have_http_status(200)
      end
  end
end
