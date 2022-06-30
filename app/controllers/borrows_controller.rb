class BorrowsController < ApplicationController
    before_action :auth_request
    # before_action :verify_admin, except: %i[index show]
    before_action :find_user, except: %i[index show destroy]
    before_action :find_book, except: %i[index show destroy]
    before_action :find_borrow, except: %i[create index]
    before_action :check_borrow_available, except: %i[index show destroy]

    # GET /borrows
    def index
        begin
            @borrows = Borrow.all
            # sql = "SELECT * FROM 'users' LEFT OUTER JOIN 'borrows' ON 'borrows'.'user_id' = 'users'.'id' LEFT OUTER JOIN 'books' ON 'books'.'id' = 'borrows'.'book_id'"
            # records_array = ActiveRecord::Base.connection.execute(sql)
            render json: {'borrows': @borrows}, status: :ok
        rescue ActiveRecord::ActiveRecordError
            render json: { status: 'error', message: @borrows.errors.full_messages },
            status: :unprocessable_entity
        end
    end
    
    # GET /borrows/{id}
    def show
        begin
            user = User.find(@borrow.user_id)
            book = Book.find(@borrow.book_id)
            render json: {'relation': @borrow, 'user': user, 'book': book}, status: :ok
        rescue ActiveRecord::ActiveRecordError
            render json: { status: 'error', message: 'error show data' },
            status: :unprocessable_entity
        end
    end

    # POST /borrows
    def create
        begin
            if @user.books << @book
                date_rent = DateTime.now.getlocal.at_midnight
                date_return = date_rent + 2.months
                unless Borrow.last.update(date_rent: date_rent, date_return: date_return)
                    render json: { status: 'error', message: @user.books.errors.full_messages },
                        status: :unprocessable_entity
                else
                    render json: { status: 'success', data: @user.books }, status: :ok
                end
            else
                render json: { status: 'error', message: @user.books.errors.full_messages },
                    status: :unprocessable_entity
            end
        rescue => exception
            render json: { status: 'error', message: "relation can't duplicate" },
            status: :unprocessable_entity
        end
        
    end

    # PUT /borrows
    def update
        @borrow = Borrow.find(params[:_id])
        unless @borrow.update(user_id: @user.id, book_id: @book.id)
            render json: { status: 'error', message: @borrow.errors.full_messages },
                status: :unprocessable_entity
        else
            render json: { status: 'success', data: @borrow }, status: :ok
        end
    end

    # DELETE /borrows/{id}
    def destroy
        unless @borrow.destroy
            render json: { status: 'error', message: 'Borrow not deleted' }, status: :unprocessable_entity
        else  
            render json: { status: 'success', message: 'Borrow deleted' }, status: :ok
        end
    end

    private
    def find_borrow
        @borrow = Borrow.find(params[:_id])
        rescue ActiveRecord::RecordNotFound
            render json: { status: 'error', message: 'Borrow not found' }, status: :not_found
    end 

    def find_user
        @user = auth_request
        rescue ActiveRecord::RecordNotFound
          render json: { status: 'error' , message: 'User not found' }, status: :not_found
    end  

    def find_book
        @book = Book.find(params[:book_id])
        rescue ActiveRecord::RecordNotFound
            render json: { status: 'error', message: 'Book not found' }, status: :not_found
    end

    def check_borrow_available
        flag = 0
        @borrowed =  Borrow.where(user_id: @user.id, is_return: false)
        if @borrowed
            @borrowed.each do |borrow|
                if borrow.date_return < DateTime.now.getlocal.at_midnight
                    borrow.update_attribute('is_return', true)
                else
                    flag += 1
                end
            end
        end

        if flag >= 3
            render json: { status: 'error', message: "Can't rent book, already rent 3 books" }, status: :forbidden
        end
    end
    
end
