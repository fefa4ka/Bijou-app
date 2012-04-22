class Photo < ActiveRecord::Base
  belongs_to :missings
        
  # http://thewebfellas.com/blog/2010/1/31/paperclip-vs-amazon-s3-european-buckets    
  has_attached_file :photo,
    :styles => {
      :thumb  => ["100x100#", :jpg],
      :small  => ["160x160#", :jpg],
      :medium => ["300x300>", :jpg],
      :large  => ["700x700>", :jpg] 
    },
    :storage => :s3,
    :s3_credentials => "#{Rails.root}/config/s3.yml",
    :url  => ":s3_domain_url",
    :path => "photos/:id/:style.:extension"
    #:path => "photos/:id/:style/:filename"


end