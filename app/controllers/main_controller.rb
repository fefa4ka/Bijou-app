# encoding: utf-8

class MainController < ApplicationController            
  def index                             
    if current_user
      redirect_to report_path
    end

    @missings = Missing.where(:published => 1)
  end
end
