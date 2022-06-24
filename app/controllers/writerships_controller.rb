class WritershipsController < ApplicationController
    before_action :auth_request
    before_action :verify_user, except: %i[index show]
    before_action :find_writer, except: %i[index show destroy]
    before_action :find_book, except: %i[index show destroy]
    before_action :find_writership, except: %i[create index]
    
    # GET /writerships
    def index
        # @writerships = Book.preload(:writers)
        # @writerships = Book.includes(:writers)
        # @books = Book.joins(:writers).readonly(false)
        # @writers = Writer.joins(:books).readonly(false)
        # sql = "SELECT * FROM 'books'"
        sql = "SELECT * FROM 'books' LEFT OUTER JOIN 'writerships' ON 'writerships'.'book_id' = 'books'.'id' LEFT OUTER JOIN 'writers' ON 'writers'.'id' = 'writerships'.'writer_id'"
        # sql = "SELECT * FROM 'writers' LEFT OUTER JOIN 'writerships' ON 'writerships'.'writer_id' = 'writers'.'id' LEFT OUTER JOIN 'books' ON 'books'.'id' = 'writerships'.'book_id'"
        @writerships = Writership.all
        records_array = ActiveRecord::Base.connection.execute(sql)
        render json: ['writerships': @writerships, 'data':records_array], status: :ok
    end

    # GET /writerships/{id}
    def show
        book = Book.find(@writership.book_id)
        writer = Writer.find(@writership.writer_id)
        render json: ['relation': @writership, 'book': book, 'writer': writer], status: :ok
    end
    
    # POST /writerships
    def create
        if @book.writers << @writer
            render json: @book.writers, status: :created
        else
            render json: { errors: @book.writers.errors.full_messages },
                status: :unprocessable_entity
        end
    end

    # PUT /writerships
    def update
        @writership = Writership.find(params[:_id])
        unless @writership.update(book_id: @book.id, writer_id: @writer.id)
            render json: { errors: @writership.errors.full_messages },
                status: :unprocessable_entity
        else
            render json: @writership, status: :ok
        end
        
    end

    # DELETE /writership/{id}
    def destroy
        unless @writership.destroy
            render json: { errors: 'Writership not deleted' }, status: :not_found
        else  
            render json: { body: 'Writership deleted' }, status: :ok
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

    def find_writership
        @writership = Writership.find(params[:_id])
        rescue ActiveRecord::RecordNotFound
            render json: { errors: 'Writership not found' }, status: :not_found
    end 

    def find_book
        @book = Book.find(params[:book_id])
        rescue ActiveRecord::RecordNotFound
            render json: { errors: 'Book not found' }, status: :not_found
    end

    def find_writer
        @writer = Writer.find(params[:writer_id])
        rescue ActiveRecord::RecordNotFound
            render json: { errors: 'Writer not found' }, status: :not_found
    end    
end
