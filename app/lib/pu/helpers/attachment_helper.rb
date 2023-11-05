# frozen_string_literal: true

module Pu
  module Helpers
    module AttachmentHelper
      def attachment_preview(attachments, **options)
        clamp_content begin
          tag.div class: [options[:identity_class], 'attachment-preview-container d-flex flex-wrap gap-1 my-1'],
                  data: { controller: 'attachment-preview-container' } do
            Array(attachments).each do |attachment|
            	next unless attachment.file.present?

              concat begin
                tag.div class: [options[:identity_class], 'attachment-preview d-inline-block text-center'],
                        title: attachment.file.original_filename,
                        data: {
                          controller: 'attachment-preview',
                          attachment_preview_mime_type_value: attachment.file.mime_type
                        } do
                  tag.figure class: 'figure my-1', style: 'width: 160px;' do
                    concat attachment_preview_thumnail(attachment)
                    concat begin
                      tag.figcaption class: 'figure-caption text-truncate' do
                        concat link_to(attachment.file.original_filename, attachment.file_url, class: 'text-decoration-none',
                                                                                               target: :blank)
                        if block_given?
                          elements = Array(yield attachment).compact
                          elements.each { |elem| concat elem }
                        end
                      end
                    end
                  end
                end
              end
            end
          end
        end
      end

      def attachment_preview_thumnail(attachment)
      	return unless attachment.file.present?

        # Any changes made here must be reflected in attachment_input_controller#buildPreviewTemplate

        if false && true # false && attachment.representable?
          link_to attachment_route_args(attachment), target: :blank, class: 'd-block' do
            image_tag attachment_representation(attachment, resize_to_fill: [150, 150]), class: 'img-thumbnail'
          end
        else
          tag.div class: 'd-inline-block img-thumbnail', data: { attachment_preview_target: 'thumbnail' } do
            extension = "#{attachment.file.extension}"
            link_to extension, attachment.file_url, class: 'd-block text-decoration-none user-select-none fs-5 font-monospace text-body-secondary',
                                                    style: 'width:150px; height:150px; line-height: 150px;',
                                                    target: :blank,
                                                    data: { attachment_preview_target: 'thumbnailLink' }
          end
        end
      end

      def attachment_representation(attachment, **options)
        attachment.representation(**options)
      end

      def attachment_route_args(attachment)
        attachment
      end
    end
  end
end
