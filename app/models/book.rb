class Book < ApplicationRecord
    include ImageUploader::Attachment(:image)
    has_many :writerships
    has_many :writers, -> { distinct }, through: :writerships
    has_many :borrows
    has_many :users, -> { distinct }, through: :borrows
    # has_one_attached :cover_image
    # validates :cover_image, attached: true, size: { less_than: 10.megabytes , message: 'is too large' }, content_type: [:png, :jpg, :jpeg]
    # validate :acceptable_image

    # def acceptable_image
    #     return unless cover_image.attached?
      
    #     unless cover_image.byte_size <= 5.megabyte
    #       errors.add(:cover_image, "is too big")
    #     end

    #     acceptable_types = ["image/jpeg", "image/png"]
    #     unless acceptable_types.include?(cover_image.content_type)
    #         errors.add(:main_image, "must be a JPEG or PNG")
    #     end
    # end
end
