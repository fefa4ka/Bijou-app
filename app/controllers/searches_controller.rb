class SearchesController < InheritedResources::Base
  def index
    @search = Search.new
  end
end
