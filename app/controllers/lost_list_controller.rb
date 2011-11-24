# encoding: utf-8

class LostListController < ApplicationController
  def index                            
      # @user_city = "Москва"
      @missings = Missing.all   
      @request = request
      
  end

end
