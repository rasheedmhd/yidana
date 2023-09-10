# frozen_string_literal: true

# Job roles
class JobRole
  include ::InMemoryHashCollection

  HASH = {
    backend: 'Backend Developer',
    data_science: 'Data Scientist',
    database_admin: 'Database Administrator',
    designer: 'Designer',
    desktop: 'Desktop Developer',
    devops: 'DevOps',
    embedded: 'Embedded Developer',
    frontend: 'Frontend Developer',
    full_stack: 'Full Stack Developer',
    graphics_game: 'Graphics/Game Developer',
    mobile: 'Mobile Developer',
    product_manager: 'Product Manager',
    qa: 'QA/Test Developer',
    system_admin: 'System Administrator'
  }.sort.to_h.stringify_keys.freeze
end
