require 'rails_helper'

RSpec.describe "Books", type: :request do
  let(:user) { FactoryBot.create(:user, username: 'user', email: 'user@gmail.com', password: 'password', password_confirmation: 'password') }
  let(:admin) { FactoryBot.create(:user, username: 'admin', email: 'admin@gmail.com', password: 'password', password_confirmation: 'password', is_admin: true) }
  let(:book) { FactoryBot.create(:book, title: 'Laskar Pelangi') }

  def json
    JSON.parse(response.body)
  end

  describe 'CREATE /books/{id}' do
    it 'responds with JSON with JWT and admin' do
      post "/auth/login", params: {email: admin.email, password: 'password'}
      token = json["token"]
      get "/books/#{book.id}", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
      expect(response).to have_http_status(200)
    end

    # it 'responds with JSON with JWT and not admin' do
    #   post "/auth/login", params: {email: user.email, password: 'password'}
    #   token = json["token"]
    #   get "/books/#{book.id}", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
    #   expect(response).to have_http_status(403)
    # end
  end

  describe 'GET /books' do
    it 'reponds invalid request without JWT' do
      get '/books'
      expect(response).to have_http_status(401)
      expect(response.body).to match("\"errors\":\"Nil JSON web token")
    end

    it 'responds JSON with JWT' do
      post "/auth/login", params: {email: user.email, password: 'password'}
      token = json["token"]
      get '/books', headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
      expect(response).to have_http_status(200)
      # expect(json.size).to eq(2)
    end
  end

  describe 'GET /books/{id}' do
    it 'responds JSON with JWT' do
      post "/auth/login", params: {email: user.email, password: 'password'}
      token = json["token"]
      get "/books/#{book.id}", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
      expect(response).to have_http_status(200)
    end
  end

  # describe "PUT /books{id}" do
  #   it 'responds JSON with JWT' do
  #     post "/auth/login", params: {email: user.email, password: 'password'}
  #     token = json["token"]
  #     put :update, params: {id: book.id, book: {synopsis: "Cerita tentang anak muda mengejar mimpi"}} , headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
  #     expect(response).to have_http_status(200)
  #   end
  # end

  describe "DELETE /books/{id}" do
    it 'responds JSON with JWT' do
      post "/auth/login", params: {email: user.email, password: 'password'}
      token = json["token"]
      get "/books/#{book.id}", headers: {"Authorization": "Bearer #{token}", "Accept": "application/json"}
      expect(response).to have_http_status(200)
    end
  end

end
