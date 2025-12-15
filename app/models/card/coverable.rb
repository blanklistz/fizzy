module Card::Coverable
  extend ActiveSupport::Concern

  def cover_image
    @cover_image ||= find_cover_image
  end

  def cover_image?
    cover_image.present?
  end

  private
    def find_cover_image
      image_from_attachment || image_from_description || image_from_comments
    end

    def image_from_attachment
      image if image.attached?
    end

    def image_from_description
      first_image_from_rich_text(description)
    end

    def image_from_comments
      comments.chronologically.each do |comment|
        if (found_image = first_image_from_rich_text(comment.body))
          return found_image
        end
      end

      nil
    end

    def first_image_from_rich_text(rich_text)
      return nil if rich_text.blank?

      # Check uploaded attachments first
      rich_text.embeds.each do |embed|
        if embed.image?
          return embed
        end
      end

      # Check remote images
      if rich_text.body.present?
        rich_text.body.attachables.each do |attachable|
          if attachable.is_a?(ActionText::Attachables::RemoteImage)
            return attachable
          end
        end
      end

      nil
    end
end
