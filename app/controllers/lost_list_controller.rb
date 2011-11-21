class LostListController < ApplicationController
  def index                            
      # @user_city = "Москва"
      @missings = Missing.all   
      @request = request
      
  end

end
