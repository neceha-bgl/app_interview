module Api
  module V1
    class UsersController < BaseController
      doorkeeper_for :all
      respond_to :json

      def show
        respond_with current_user.to_api
      end
    end
  end
end

