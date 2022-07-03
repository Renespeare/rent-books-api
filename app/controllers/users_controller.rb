class UsersController < ApplicationController
  before_action :auth_request, except: :create
  before_action :find_user, except: %i[create index]

  # GET /users
  def index
    begin
      @users = User.all.limit(params[:limit]).offset(params[:page].to_i - 1)
      render json: { status: 'success', data: @users, limit: params[:limit], links:{prev: "/users?page=#{params[:page].to_i - 1}&limit=#{params[:limit]}", next: "/users?page=#{params[:page].to_i + 1}&limit=#{params[:limit]}"} }, status: :ok
    rescue ActiveRecord::ActiveRecordError
      render json: { status: 'error', message: @users.errors.full_messages },
      status: :unprocessable_entity
    end 
  end

  # GET /users/{username}
  def show
    render json: { status: 'success', data: @user }, status: :ok
  end

  # POST /users
  def create
    @user = User.new(user_params)
    if @user.save
      render json: { status: 'success', data: @user }, status: :created
    else
      render json: { status: 'error', message: @user.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /users/{username}
  def update
    current_user = auth_request
    if current_user.id != @user.id
      render json: { status: 'error', message: "Can't have access" },
             status: :forbidden
    else
      unless @user.update(update_user_params)
        render json: { status: 'error', message: @user.errors.full_messages },
               status: :unprocessable_entity
      else
        render json: { status: 'success', data: @user }, status: :ok
      end
    end
  end

  # DELETE /users/{username}
  def destroy
    current_user = auth_request
    if current_user.id != @user.id
      render json: { status: 'error', message: "Can't have access" },
             status: :forbidden
    else
      unless @user.destroy
        render json: { status: 'error', message: 'User not deleted' }, status: :unprocessable_entity
      else  
        render json: { status: 'success', message: 'User deleted' }, status: :ok
      end
    end
  end

  private

  def find_user
    @user = User.find_by_username!(params[:_username])
    rescue ActiveRecord::RecordNotFound
      render json: { status: 'error' , message: 'User not found' }, status: :not_found
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
