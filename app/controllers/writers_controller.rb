class WritersController < ApplicationController
    before_action :auth_request
    before_action :verify_admin, except: %i[index show]
    before_action :find_writer, except: %i[create index]
  
    # GET /writers
    def index
        begin
            @writers = Writer.all.limit(params[:limit]).offset(params[:page].to_i - 1)
            render json: { status: 'success', data: @writers, limit: params[:limit], links:{prev: "/writers?page=#{params[:page].to_i - 1}&limit=#{params[:limit]}", next: "/writers?page=#{params[:page].to_i + 1}&limit=#{params[:limit]}"} }, 
            status: :ok
        rescue ActiveRecord::ActiveRecordError
            render json: { status: 'error', message: @writers.errors.full_messages },
            status: :unprocessable_entity
        end
        
    end
  
    # GET /writers/{id}
    def show
        render json: { status: 'success', data: @writer }, status: :ok
    end

    # POST /writers
    def create
        @writer = Writer.new(writer_params)
        if @writer.save
            render json: { status: 'success', data: @writer }, status: :created
        else
            render json: { status: 'error', message: @writer.errors.full_messages },
                status: :unprocessable_entity
        end
    end

    # PUT /writers/{id}
    def update
        unless @writer.update(writer_params)
            render json: { status: 'error', message: @writer.errors.full_messages },
                status: :unprocessable_entity
        else
            render json: { status: 'success', data: @writer }, status: :ok
        end
    end
    
    # DELETE /writers/{id}
    def destroy
        unless @writer.destroy
            render json: { status: 'error', message: 'Writer not deleted' }, status: :unprocessable_entity
        else  
            render json: { status: 'success', message: 'Writer deleted' }, status: :ok
        end
    end

    private
    def verify_admin
        @current_user = auth_request
        if @current_user.is_admin != true
            render json: { status: 'error', message: "Can't have access" },
            status: :forbidden
        end
    end
  
    def find_writer
      @writer = Writer.find(params[:_id])
      rescue ActiveRecord::RecordNotFound
        render json: { status: 'error', message: 'Writer not found' }, status: :not_found
    end
    
    def writer_params
      params.permit(
        :name
      )
    end
end
