module YandexInflect    
  private
    def self.cache_lookup(word)
      value = $redis.hvals(word.to_s)   
      if value.size > 0
        value
      else
        nil
      end
    end
  
    def self.cache_store(word, value)   
      value.each_with_index do |el,index|
        $redis.hmset(word.to_s, index, el)
      end
    end
end

# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format
# (all these examples are active by default):
# ActiveSupport::Inflector.inflections do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end
