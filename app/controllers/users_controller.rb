class UsersController < ApplicationController
  before_action :authorize_request, except: :create
  before_action :find_user, except: %i[create index]

  def index
    @users = User.all
    render json: @users, status: :ok
  end

  # GET /users/{username}
  def show
    render json: @user, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: @user, status: :created
    else
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /users/{username}
  def update
    unless @user.update(update_user_params)
      render json: { errors: @user.errors.full_messages },
             status: :unprocessable_entity
    else
      render json: @user, status: :ok
    end
  end

  # DELETE /users/{username}
  def destroy
    unless @user.destroy
      render json: { errors: 'User not delete' }, status: :not_found
    else  
      render json: { body: 'User deleted' }, status: :ok
    end
  end

  private

  def find_user
    @user = User.find_by_username!(params[:_username])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'User not found' }, status: :not_found
  end

  def user_params
    params.permit(
      :username, :email, :password, :password_confirmation, :is_admin
    )
  end

  def update_user_params
    user_params = params.permit(
      :phone_number, :address, :is_admin, :password, :password_confirmation
    )
     # Remove the password and password confirmation keys for empty values
    user_params.delete(:password) unless user_params[:password].present?
    user_params.delete(:password_confirmation) unless user_params[:password_confirmation].present?

    user_params
  end
end
