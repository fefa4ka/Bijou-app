class Photo < ActiveRecord::Base
  belongs_to :missings
  
  # Папка с фотографиями
  PHOTO_STORE = File.join RAILS_ROOT, 'public', 'photos'
  
  
  def load_photo_file=(data)
    self.filename = data.original_filename
    @photo_data = data
    save_photo
  end
  
  def save_photo
    if @photo_data
      name = File.join PHOTO_STORE, self.filename
      File.open(name, 'wb') do |f|
        f.write(@photo_data.read)
      end
    end
  end
  
end
