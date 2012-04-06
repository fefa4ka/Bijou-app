# encoding: utf-8

class MainController < ApplicationController            
  caches_page :index
  
  def index                             
    @missings = Missing.where(:published => 1)
    @search = Search.new
  end
end
