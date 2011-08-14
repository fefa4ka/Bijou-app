# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)

# Список пропавших
Missing.delete_all

Missing.create([{
  :name => "Никита Михалков",
  :description => "",
  :image_url => "001.jpg"
},{
  :name => "Кузьма Прутков",
  :description => "",
  :image_url => "002.jpg"
},{
  :name => "Пьер Безухов",
  :description => "",
  :image_url => "003.jpg"
},{
  :name => "Кузьма Прутков",
  :description => "",
  :image_url => "002.jpg"
},{
  :name => "Пьер Безухов",
  :description => "",
  :image_url => "003.jpg"
},{
  :name => "Никита Михалков",
  :description => "",
  :image_url => "001.jpg"
},{
  :name => "Пьер Безухов",
  :description => "",
  :image_url => "003.jpg"
},{
  :name => "Кузьма Прутков",
  :description => "",
  :image_url => "002.jpg"
},{
  :name => "Пьер Безухов",
  :description => "",
  :image_url => "003.jpg"
}])
