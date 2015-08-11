module V1
  class UsersController < BaseController

      # Shows a user. /users/getinfo route
      #
      # text  - The user_token String.
      #
      # Returns a User object.
      def index
        #return render json: 'In Index'
        fail ActiveRecord::RecordNotFound, 'User not found'  if params[:user_token].blank?
        @user  = Account.get_user(params[:user_token])

        fail ActiveRecord::RecordNotFound, 'User not found'  if @user.nil?
      end

      # Creates a new user Account.
      #
      # Returns a User object.
      def create_user
        @user = Account.new.create_user(params)

        if @user.class.name == 'User'
          @message = { message: 'User created sucessfully' }
        else
          fail Exception, "User not created: #{@user.inspect}"
        end
        render 'index'
      end

      # Creates a new user Account.
      #
      # Returns a User object.
      def update_user
        if params[:user_token].blank?
          return fail ActiveRecord::RecordNotFound, 'User not found'
        end

        @user = Account.new.update_user(params)

        if @user.class.name == 'User'
          @message = { message: 'User updated sucessfully' }
        else
          fail Exception, "User not updated: #{@user.inspect}"
        end
        render 'index'
      end

      # Shows an user.
      #
      # text  - The user_token String.
      #
      # Returns a User object.
      def get_token
        #return render json: 'gettoken'
        #customer_profile_external_id
        @user  = Account.get_token(params)

        if @user.nil?
          fail ActiveRecord::RecordNotFound, 'User not found'
        end

        render 'index'
      end

      # Create a user_token for the Account.
      #
      # text  - The user_token String.
      #
      # Returns a User object.
      def create_token
        @user = Account.create_token(params)

        fail ActiveRecord::RecordNotFound, 'User not found'  if @user.nil?

        render 'index'
      end

      # Disable an Account.
      #
      # text  - The user_token String.
      #
      # Examples
      #
      #   show('xVpK6SgP2NAhVtA-ygEIww')
      #   # => user
      #
      # Returns a User object.
      def delete
        if params[:user_token].blank?
          return fail ActiveRecord::RecordNotFound, 'User not found'
        end

        result = Account.new.disable_user(params[:user_token])

        if result
          @message = { message: 'User sucesfully deleted'}
        else
          @message = { message: 'Something went wrong, user not deleted'}
        end
      end

      def errorr(error_name)
        errors_by_name = { not_valid_user: { code: '2', message: 'Not valid Account.' },
                         register_error: { code: '3', message: 'User could not be found in subscriptions.' },
                         epub_user:      { code: '4', message: 'User could not be found in IBJ.' },
                         connection:     { code: '5', message: 'Connection could not be established.' }
                       }

        errors_by_name[error_name]
      end
    end
end
