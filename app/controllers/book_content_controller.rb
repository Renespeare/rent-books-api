class BookContentController < ApplicationController
    before_action :auth_request
    before_action :verify_admin
    before_action :find_book_content, except: %i[create index]

    # GET /book-content
    def index
        begin
            book_contents = BookContent.select((BookContent.attribute_names - ['pdf_data'])).limit(params[:limit]).offset(params[:page].to_i - 1)
            @result = book_contents.as_json
            @result.each do |item|
                data = BookContent.find(item['id'])
                if data.pdf != nil
                    item['content'] = {filename: data.pdf_data['metadata']['filename'], link: "#{request.base_url}/uploads/#{data.pdf_data['id']}"}
                else
                    item['content'] = nil
                end
            end
            render json: { status: 'success', data: @result, limit: params[:limit], links:{prev: "/book-content?page=#{params[:page].to_i - 1}&limit=#{params[:limit]}", next: "/book_content?page=#{params[:page].to_i + 1}&limit=#{params[:limit]}"} }, status: :ok
        rescue ActiveRecord::ActiveRecordError
            render json: { status: 'error', message: 'Get data error' },
            status: :unprocessable_entity
        end
        
    end

    # GET /book-content/{id}
    def show
        begin
        if @book_content.pdf_data != nil
            query = BookContent.select((BookContent.attribute_names - ['pdf_data'])).find(params[:_id])
            result = query.as_json
            result['content'] = {filename: @book_content.pdf_data['metadata']['filename'], link: "#{request.base_url}/uploads/#{@book_content.pdf_data['id']}"}
            render json: { status: 'success', data: result }, status: :ok
        else
            render json: { status: 'success', data: @book_content }, status: :ok
        end
        rescue => exception
        render json: { status: 'error', message: "Get data failed" }, status: :unprocessable_entity
        end
        
        
        
    end
    
    # POST /book-content
    def create
        @book_content = BookContent.new(book_content_params)
        if @book_content.save
        render json: { status: 'success', data: @book_content }, status: :created
        else
        render json: { status: 'error', message: @book_content.errors.full_messages },
                status: :unprocessable_entity
        end
    end

    # PUT /book-content/{id}
    def update
        unless @book_content.update(book_content_params)
        render json: { status: 'error', message: @book_content.errors.full_messages },
                status: :unprocessable_entity
        else
        render json: { status: 'success', data: @book_content }, status: :ok
        end
    end
    
    # DELETE /book-content/{id}
    def destroy
        unless @book_content.destroy
        render json: { status: 'error', message: 'Book content not deleted' }, status: :unprocessable_entity
        else  
        render json: { status: 'success', message: 'Book content deleted' }, status: :ok
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

    def find_book_content
        @book_content = BookContent.find(params[:_id])
        rescue ActiveRecord::RecordNotFound
        render json: { status: 'error', message: 'Book content not found' }, status: :not_found
    end
    
    def book_content_params
        params.permit(
        :book_id, :pdf
        )
    end
end
