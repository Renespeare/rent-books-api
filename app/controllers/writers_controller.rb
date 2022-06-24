class WritersController < ApplicationController
    before_action :auth_request
    before_action :verify_user, except: %i[index show]
    before_action :find_writer, except: %i[create index]
  
    # GET /writers
    def index
        @writers = Writer.all
        render json: @writers, status: :ok
    end
  
    # GET /writers/{id}
    def show
        render json: @writer, status: :ok
    end

    # POST /writers
    def create
        @writer = Writer.new(writer_params)
        if @writer.save
            render json: @writer, status: :created
        else
            render json: { errors: @writer.errors.full_messages },
                status: :unprocessable_entity
        end
    end

    # PUT /writers/{id}
    def update
        unless @writer.update(writer_params)
            render json: { errors: @writer.errors.full_messages },
                status: :unprocessable_entity
        else
            render json: @writer, status: :ok
        end
    end
    
    # DELETE /writers/{id}
    def destroy
        unless @writer.destroy
            render json: { errors: 'Writer not deleted' }, status: :not_found
        else  
            render json: { body: 'Writer deleted' }, status: :ok
        end
    end

    private
    def verify_user
        @current_user = auth_request
        if @current_user.is_admin != true
            render json: { errors: "Can't have access" },
            status: :unprocessable_entity
        end
    end
  
    def find_writer
      @writer = Writer.find(params[:_id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: 'Writer not found' }, status: :not_found
    end
    
    def writer_params
      params.permit(
        :name
      )
    end
end
