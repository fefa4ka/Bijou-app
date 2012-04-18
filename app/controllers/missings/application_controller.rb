# encoding: utf-8

require 'digest/md5'
require 'net/http'

class Missings::ApplicationController < ApplicationController
  # Каталог для фоток
  impressionist :actions => [:show]   

end
