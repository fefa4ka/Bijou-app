# encoding: utf-8

class MainController < ApplicationController              
  def index                             
    @missings = Missing.where(:published => 1).limit(50)
    @search = Search.new
  end
end
