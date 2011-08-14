require 'test_helper'

class MissingTest < ActiveSupport::TestCase
  fixtures :missings
  
  def new_missing(image_url)
      Missing.new(:name => "Name of missing",
                  :description => "History of extinction",
                  :image_url => image_url)
  end
  
  test "Поля пропажи не должны быть пустые" do
    missing = Missing.new
    assert missing.invalid?
    assert missing.errors[:name].any?
    assert missing.errors[:image_url].any?
  end
  
  test "Проверка принимаемых картинок" do
      ok = %w{ fred.gif fred.jpg fred.png fred.JPG fred.Png http://a.b.c.ru/o/r/s/image.jpg }
      bad = %w{ fred.doc fred.jpg/media fred.gif.more }
      
      ok.each do |name|
        assert new_missing(name).valid?, "#{name} должен подходить"
      end
      
      bad.each do |name|
        assert new_missing(name).invalid?, "#{name} не должен подходить"
      end
  end
   
end
