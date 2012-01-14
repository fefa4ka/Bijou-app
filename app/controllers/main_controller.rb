# encoding: utf-8

class MainController < ApplicationController            
  def index                             
    if current_user && current_user.has_missing?
      redirect_to report_path
    elsif current_user && !current_user.has_missing?
      redirect_to "/missings"
    end

    @missings = Missing.where(:published => 1)
    @search = Search.new
  end
end
