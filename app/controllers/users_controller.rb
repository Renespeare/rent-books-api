class UsersController < ApplicationController
  before_action :auth_request, except: :create
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
    current_user = auth_request
    if current_user.id != @user.id
      render json: { errors: "Can't have access" },
             status: :unprocessable_entity
    else
      unless @user.update(update_user_params)
        render json: { errors: @user.errors.full_messages },
               status: :unprocessable_entity
      else
        render json: @user, status: :ok
      end
    end
  end

  # DELETE /users/{username}
  def destroy
    current_user = auth_request
    if current_user.id != @user.id
      render json: { errors: "Can't have access" },
             status: :unprocessable_entity
    else
      unless @user.destroy
        render json: { errors: 'User not deleted' }, status: :not_found
      else  
        render json: { body: 'User deleted' }, status: :ok
      end
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
      :username, :email, :password, :password_confirmation
    )
  end

  def update_user_params
    user_params = params.permit(
      :phone_number, :address
    )
  end
end
