require 'rails_helper'

RSpec.describe "Authentications", type: :request do
  it 'responds with a valid JWT' do
    post "/auth/login"
    token = JSON.parse(response.body)['token']
  
    expect { JWT.decode(token, key) }.to_not raise_error(JWT::DecodeError)
  end
end
