class BooksController < ApplicationController
  before_action :auth_request
  before_action :verify_user, except: %i[index show]
  before_action :find_book, except: %i[create index]

  # GET /books
  def index
    @books = Book.all
    render json: @books, status: :ok
  end

  # GET /books/{id}
  def show
    render json: @book, status: :ok
  end
  
  # POST /books
  def create
    @book = Book.new(book_params)
    if @book.save
      render json: @book, status: :created
    else
      render json: { errors: @book.errors.full_messages },
             status: :unprocessable_entity
    end
  end

  # PUT /books/{id}
  def update
    unless @book.update(book_params)
      render json: { errors: @book.errors.full_messages },
              status: :unprocessable_entity
    else
      render json: @book, status: :ok
    end
  end
  
  # DELETE /books/{id}
  def destroy
    unless @book.destroy
      render json: { errors: 'Book not deleted' }, status: :not_found
    else  
      render json: { body: 'Book deleted' }, status: :ok
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

  def find_book
    @book = Book.find(params[:_id])
    rescue ActiveRecord::RecordNotFound
      render json: { errors: 'Book not found' }, status: :not_found
  end
  
  def book_params
    params.permit(
      :writer_id, :title, :synopsis, :genre, :publisher, :published_year, :page_count, :isbn, :contents
    )
  end

end
