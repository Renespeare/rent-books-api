module RequestSpecHelper
    def json
      JSON.parse(response.body)
    end
  
    def confirm_and_login_user(user)
    #   get '/users/confirm', params: {token: user.confirmation_token}
      post '/auth/login', params: {email: user.email, password: 'password'}
      return json['token']
    end
end