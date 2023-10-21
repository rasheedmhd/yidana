# frozen_string_literal: true

module AttachmentPreserver
  def attachment(_wrapper_options = nil)
    return unless value.present?

    template.display_attachment(value) do |attachment|
      if value.respond_to?(:each)
        [
          @builder.hidden_field(attribute_name, multiple: true, value: attachment.signed_id),
          template.content_tag(:p, 'Remove', class: 'text-danger',
                                             role: :button,
                                             data: { action: 'click->attachment#remove' })
        ]
      end
    end
  end

  private

  def value
    @value ||= object.send(attribute_name) if object && object.respond_to?(attribute_name)
  end
end

# Register the component in Simple Form.
SimpleForm.include_component(AttachmentPreserver)
