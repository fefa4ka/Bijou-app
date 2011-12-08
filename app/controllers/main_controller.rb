# encoding: utf-8

class MainController < ApplicationController            
  def index                             
    @missings = Missing.where(:published => 1)
    logger.debug(session.inspect)
  end
end
