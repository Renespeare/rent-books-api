class BooksController < ApplicationController
  before_action :auth_request
  before_action :verify_admin, except: %i[index show]
  before_action :find_book, except: %i[create index]

  # GET /books
  def index
    begin
      @books = Book.all
      render json: { status: 'success', data: @books }, status: :ok
    rescue ActiveRecord::ActiveRecordError
      render json: { status: 'error', message: @books.errors.full_messages },
      status: :unprocessable_entity
    end
    
  end

  # GET /books/{id}
  def show
    render json: { status: 'success', data: @book }, status: :ok
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
      :writer_id, :title, :synopsis, :genre, :publisher, :published_year, :page_count, :isbn, :contents
    )
  end

end
