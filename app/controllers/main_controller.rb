# encoding: utf-8

class MainController < ApplicationController            
  def index                             
    @missings = Missing.all
    logger.debug(session.inspect)
  end
end
