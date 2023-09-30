# frozen_string_literal: true

module ApplicationHelper
  include Pu::Helpers

  def joel_test_details(value)
    render 'joel_test', value:
  end
end
