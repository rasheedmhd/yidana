# frozen_string_literal: true

module Pu
  module Helpers
    module PaginationHelper
      include Pagy::Frontend

      #
      # Renders pagination given a pagy instance
      #
      # Customize the rendered pagination using a custom `_pagination` partial close to your resource
      #
      # @param [<Pagy>] pagy pagy instance
      #
      def pagination(pagy)
        # Renders a partial allows us to leverage the view resolution hierachy for customization
        render partial: 'pagination', pagy:
      end
    end
  end
end
