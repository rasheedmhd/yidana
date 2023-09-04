# frozen_string_literal: true

# == Schema Information
#
# Table name: entities
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  slug       :citext           not null
#  type       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Indexes
#
#  index_entities_on_slug           (slug)
#  index_entities_on_type_and_slug  (type,slug) UNIQUE
#  index_entities_on_user_id        (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (user_id => users.id)
#
class Recruiter < Entity
end
