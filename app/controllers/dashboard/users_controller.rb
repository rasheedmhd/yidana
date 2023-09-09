# frozen_string_literal: true

module Dashboard
  class UsersController < BaseController
    def index
      @pagy, @resources = pagy(User.all)
    end

    def show
      @resource = User.find params.require(:id)
    end

    def new
      @resource = User.new
    end

    def edit
      @resource = User.find params.require(:id)
    end

    def create
      @resource = User.new(params.require(:user).permit(:email, :password))

      if @resource.save
        redirect_to @resource, notice: 'User was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      @resource = User.find params.require(:id)

      if @resource.update(params.require(:user).permit(:email, :password))
        redirect_to @resource, notice: 'User was successfully updated.', status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @resource = User.find params.require(:id)
      @resource.destroy

      redirect_to users_url, notice: 'User was successfully deleted.', status: :see_other
    rescue ActiveRecord::InvalidForeignKey => e
      redirect_to @resource, alert: 'User cannot be deleted.'
    end
  end
end
