class ReviewsController < ApplicationController
    before_action :auth_request
    before_action :find_review, except: %i[create index]
    before_action :find_user, except: %i[index show destroy]

    # GET /reviews
    def index
        begin
            @reviews = Review.all.limit(params[:limit]).offset(params[:page].to_i - 1)
            render json: {status: 'success', data: @reviews, limit: params[:limit], links:{prev: "/reviews?page=#{params[:page].to_i - 1}&limit=#{params[:limit]}", next: "/reviews?page=#{params[:page].to_i + 1}&limit=#{params[:limit]}"}}, status: :ok
        rescue ActiveRecord::ActiveRecordError
            render json: {status: 'error', message: @reviews.errors.full_messages},
            status: :unprocessable_entity
        end
    end

    # GET /reviews/{id}
    def show
        render json: { status: 'success', data: @review }, status: :ok
    end

    # POST /reviews
    def create
        begin
            @review = Review.new(review_params)
            @review.user_id = @user.id
            if @review.save
                render json: { status: 'success', data: @review }, status: :created
            else
                render json: { status: 'error', message: @review.errors.full_messages },
                    status: :unprocessable_entity
            end
        rescue => exception
            render json: { status: 'error', message: "relation can't duplicate" },
            status: :unprocessable_entity
        end
        
    end

    # PUT /reviews/{id}
    def update
        unless @review.update(review_params)
            render json: { status: 'error', message: @review.errors.full_messages },
                    status: :unprocessable_entity
        else
            render json: { status: 'success', data: @review }, status: :ok
        end
    end

    # DELETE /reviews/{id}
    def destroy
        unless @review.destroy
            render json: { status: 'error', message: "Review not deleted"},
                    status: :unprocessable_entity
        else
            render json: { status: 'success', message: "Review deleted" }, status: :ok
        end
    end
    

    private
    def find_review
        @review = Review.find(params[:_id])
    rescue ActiveRecord::RecordNotFound
        render json: { status: 'error', message: 'Review not found' }, status: :not_found
    end

    def find_user
        @user = auth_request
        rescue ActiveRecord::RecordNotFound
          render json: { status: 'error' , message: 'User not found' }, status: :not_found
    end
  
    def review_params
        params.permit(
        :user_id, :book_id, :star, :comment
        )
    end
end
