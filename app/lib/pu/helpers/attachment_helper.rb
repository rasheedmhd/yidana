# frozen_string_literal: true

module Pu
  module Helpers
    module AttachmentHelper
      def display_attachments(attachments, &block)
        tag.div class: 'attachments d-flex flex-wrap gap-1 my-1' do
          attachments.each do |attachment|
            concat display_attachment(attachment, &block)
          end
        end
      end

      def display_attachment(attachment)
        tag.div class: 'attachment d-inline-block text-center',
                title: attachment.blob.filename,
                data: { controller: :attachment } do
          tag.figure class: 'figure my-1', style: 'width: 160px;' do
            concat display_attachment_thumnail(attachment)
            concat begin
              tag.figcaption class: 'figure-caption text-truncate' do
                concat link_to(attachment.blob.filename, attachment, class: 'text-decoration-none', target: :blank)
                if block_given?
                  elements = Array(yield attachment).compact
                  elements.each { |elem| concat elem }
                end
              end
            end
          end
        end
      end

      def display_attachment_thumnail(attachment)
        if attachment.representable?
          link_to attachment_route_args(attachment), target: :blank, class: 'd-block' do
            image_tag attachment_representation(attachment, resize_to_fill: [150, 150]), class: 'img-thumbnail'
          end
        else
          tag.div class: 'd-inline-block img-thumbnail' do
            filename = attachment.blob.filename.extension_with_delimiter
            link_to filename, attachment_route_args(attachment), class: 'd-block text-decoration-none user-select-none fs-5 font-monospace text-body-secondary',
                                                                 style: 'width:150px; height:150px; line-height: 150px;',
                                                                 target: :blank
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
