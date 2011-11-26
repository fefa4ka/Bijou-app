# encoding: utf-8

class LostListController < ApplicationController
  def index                            
      # @user_city = "Москва"
      @missings = Missing.all   
      @request = request
      @help_types = HelpType.all
      
      if params[:type] == "detective"
      	render 'detective'
	  else
	  	render 'volunteer'
  	  end
  end

end
