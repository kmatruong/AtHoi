class Micropost < ApplicationRecord
  belongs_to :user
  scope :order_desc, ->{order created_at: :desc}
  mount_uploader :picture, PictureUploader

  validates :user, presence: true
  validates :content, presence: true, length: {maximum: Settings.max_content}
  validate :picture_size

  private

  def picture_size
    return errors.add picture: t("add_pic") if picture.size > 5.megabytes
  end
end
