# frozen_string_literal: true

module Dashboard
  class OrganisationsController < BaseController
    def index
      @pagy, @resources = pagy(Organisation.all)
    end

    def show
      @resource = Organisation.find params.require(:id)
    end

    def new
      @resource = Organisation.new
    end

    def edit
      @resource = Organisation.find params.require(:id)
    end

    def create
      @resource = Organisation.new(entity: current_entity, **params.require(:organisation).permit!)

      if @resource.save
        redirect_to @resource, notice: 'Organisation was successfully created.'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      @resource = Organisation.find params.require(:id)

      if @resource.update(params.require(:organisation).permit!)
        redirect_to @resource, notice: 'Organisation was successfully updated.', status: :see_other
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @resource = Organisation.find params.require(:id)
      @resource.destroy

      redirect_to organisations_url, notice: 'Organisation was successfully deleted.', status: :see_other
    rescue ActiveRecord::InvalidForeignKey => e
      redirect_to @resource, alert: 'Organisation cannot be deleted.'
    end
  end
end
