class Photo < ActiveRecord::Base
  belongs_to :missings
            
  has_attached_file :photo,
    :styles => {
      :thumb  => ["100x100#", :jpg],
      :small  => ["160x160#", :jpg],
      :medium => ["300x300>", :jpg],
      :large  => ["700x700>", :jpg] 
  }# ,
    #     :storage => :s3,
    #     :s3_credentials => "#{RAILS_ROOT}/config/s3.yml",
    #     :path => "missings/:id/:style.:extension",
end