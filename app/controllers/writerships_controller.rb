class WritershipsController < ApplicationController
    before_action :auth_request
    before_action :verify_admin, except: %i[index show]
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
        # sql = "SELECT * FROM 'writers' LEFT OUTER JOIN 'writerships' ON 'writerships'.'writer_id' = 'writers'.'id' LEFT OUTER JOIN 'books' ON 'books'.'id' = 'writerships'.'book_id'"
        begin
            sql = "SELECT * FROM 'books' LEFT OUTER JOIN 'writerships' ON 'writerships'.'book_id' = 'books'.'id' LEFT OUTER JOIN 'writers' ON 'writers'.'id' = 'writerships'.'writer_id'"
            @writerships = Writership.all
            records_array = ActiveRecord::Base.connection.execute(sql)
            render json: {'writerships': @writerships, 'data':records_array}, status: :ok
        rescue ActiveRecord::ActiveRecordError
            render json: { status: 'error', message: @writerships.errors.full_messages },
            status: :unprocessable_entity
        end
       
    end

    # GET /writerships/{id}
    def show
        begin
            book = Book.find(@writership.book_id)
            writer = Writer.find(@writership.writer_id)
            render json: {'relation': @writership, 'book': book, 'writer': writer}, status: :ok
        rescue ActiveRecord::ActiveRecordError
            render json: { status: 'error', message: 'error show data' },
            status: :unprocessable_entity
        end
    end
    
    # POST /writerships
    def create
        begin
            if @book.writers << @writer
                render json: { status: 'success', data: @book.writers }, status: :created
            else
                render json: { status: 'error', message: @book.writers.errors.full_messages },
                    status: :unprocessable_entity
            end
        rescue => exception
            render json: { status: 'error', message: "relation can't duplicate" },
                    status: :unprocessable_entity
        end
       
    end

    # PUT /writerships
    def update
        @writership = Writership.find(params[:_id])
        unless @writership.update(book_id: @book.id, writer_id: @writer.id)
            render json: { status: 'error', message: @writership.errors.full_messages },
                status: :unprocessable_entity
        else
            render json: { status: 'success', data: @writership }, status: :ok
        end
        
    end

    # DELETE /writerships/{id}
    def destroy
        unless @writership.destroy
            render json: { status: 'error', message: 'Writership not deleted' }, status: :unprocessable_entity
        else  
            render json: { status: 'success', message: 'Writership deleted' }, status: :ok
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

    def find_writership
        @writership = Writership.find(params[:_id])
        rescue ActiveRecord::RecordNotFound
            render json: { status: 'error', message: 'Writership not found' }, status: :not_found
    end 

    def find_book
        @book = Book.find(params[:book_id])
        rescue ActiveRecord::RecordNotFound
            render json: { status: 'error', message: 'Book not found' }, status: :not_found
    end

    def find_writer
        @writer = Writer.find(params[:writer_id])
        rescue ActiveRecord::RecordNotFound
            render json: { status: 'error', message: 'Writer not found' }, status: :not_found
    end    
end
