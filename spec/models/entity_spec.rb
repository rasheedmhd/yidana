# frozen_string_literal: true

require 'rails_helper'
require 'models/entity_spec.auto'

RSpec.describe Entity, type: :model do
  include_examples 'Automatically Generated Entity Examples'

  subject { build :entity }

  # Add your custom examples here
end
