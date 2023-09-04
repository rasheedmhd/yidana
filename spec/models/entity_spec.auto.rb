# frozen_string_literal: true

# This file is generate automatically
# Do not modify it by hand
# Add your customizations to `entity.rb` instead
RSpec.shared_examples 'Automatically Generated Entity Examples' do
  it 'is valid with valid attributes' do
    expect(subject).to be_valid
  end

  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(80) }
    it { should validate_presence_of(:slug) }
    it { should validate_uniqueness_of(:slug).scoped_to(:type) }
    it { should validate_length_of(:slug).is_at_least(3).is_at_most(100) }
  end

  describe 'associations' do
    # belongs_to
    it { should belong_to(:user) }

    # has_one

    # has_many
  end
end
