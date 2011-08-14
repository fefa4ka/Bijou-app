class Missing < ActiveRecord::Base
  default_scope :order => 'updated_at'
  
  validates :name, :image_url, :presence => true
  validates :image_url, :format => {
    :with => %r{\.(gif|jpg|png)$}i,
    :message  => 'должен быть картинкой'
  }
end
