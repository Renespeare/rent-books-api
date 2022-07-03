class BooksController < ApplicationController
  before_action :auth_request
  before_action :verify_admin, except: %i[index show]
  before_action :find_book, except: %i[create index]

  # GET /books
  def index
    begin
      # sql = "SELECT 'writer_id', 'title', 'synopsis', 'genre', 'image', 'publisher', 'published_year', 'page_count', 'isbn' FROM 'books'"
      # records_array = ActiveRecord::Base.connection.execute(sql)
      books = Book.select((Book.attribute_names - ['image_data'])).limit(params[:limit]).offset(params[:page].to_i - 1)
      @result = books.as_json
      @result.each do |item|
        cover = Book.find(item['id'])
        if cover.image_data != nil
          item['cover_image'] = {filename: cover.image_data['metadata']['filename'], link: "#{request.base_url}/uploads/#{cover.image_data['id']}"}
        else
          item['cover_image'] = nil
        end
       
      end
      render json: { status: 'success', data: @result, limit: params[:limit], links:{prev: "/books?page=#{params[:page].to_i - 1}&limit=#{params[:limit]}", next: "/books?page=#{params[:page].to_i + 1}&limit=#{params[:limit]}"} }, status: :ok
    rescue ActiveRecord::ActiveRecordError
      render json: { status: 'error', message: 'Get data error' },
      status: :unprocessable_entity
    end
    
  end

  # GET /books/{id}
  def show
    begin
      if @book.image_data != nil
        query = Book.select((Book.attribute_names - ['image_data'])).find(params[:_id])
        result = query.as_json
        result['cover_image'] = {filename: @book.image_data['metadata']['filename'], link: "#{request.base_url}/uploads/#{@book.image_data['id']}"}
        render json: { status: 'success', data: result }, status: :ok
      else
        render json: { status: 'success', data: @book }, status: :ok
      end
    rescue => exception
      render json: { status: 'error', message: "Get data failed" }, status: :unprocessable_entity
    end
    
    
    
  end
  
  # POST /books
  def create
    @book = Book.new(book_params)
    if @book.save
      render json: { status: 'success', data: @book }, status: :created
    else
      render json: { status: 'error', message: @book.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /books/{id}
  def update
    unless @book.update(book_params)
      render json: { status: 'error', message: @book.errors.full_messages },
              status: :unprocessable_entity
    else
      render json: { status: 'success', data: @book }, status: :ok
    end
  end
  
  # DELETE /books/{id}
  def destroy
    unless @book.destroy
      render json: { status: 'error', message: 'Book not deleted' }, status: :unprocessable_entity
    else  
      render json: { status: 'success', message: 'Book deleted' }, status: :ok
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

  def find_book
    @book = Book.find(params[:_id])
    rescue ActiveRecord::RecordNotFound
      render json: { status: 'error', message: 'Book not found' }, status: :not_found
  end
  
  def book_params
    params.permit(
      :writer_id, :title, :synopsis, :genre, :image, :publisher, :published_year, :page_count, :isbn
    )
  end

end
