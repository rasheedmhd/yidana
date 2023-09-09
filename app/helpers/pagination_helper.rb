# frozen_string_literal: true

module PaginationHelper
  include Pagy::Frontend

  def pagination(pagy)
    render partial: 'pagination', pagy:
  end
end
