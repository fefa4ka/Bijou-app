# encoding: utf-8

class MainController < ApplicationController              
  def index                             
    @missings = Missing.where(:published => 1).limit(50)   
    @amount = 1
    @amount = 45/@missings.size if @missings.size < 45
    @search = Search.new
  end
end
