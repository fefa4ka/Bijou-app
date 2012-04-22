# encoding: utf-8

module ApplicationHelper    
  # Выдаёт слово в мужском или женском роде
  # male = true мужской рож
  # male = false женский род
  def linguistic_kind(male, word)
    # Если пустое слово передано, выходим
    return word if word.nil?

    words = word.split(' ')

    # Исправляем одно слово
    if words.size() == 1 && word[0] == "@"
      word = word[1..-1]
      return word if male

      return "#{word[0..-3]}ла" if ["ёл", "ел"].include? word[-2..-1]
      return "#{word}а" if ["л", "т"].include? word[-1]
      return "#{word}ла" if word[-1] == 'г'
      return "она" if word == "он"
      result = word
    else 
      # Рекурсивно исправляем в фразе слова начинающиеся с @
      words.each_with_index do |word, index|
        if word[0] == "@"
          word = linguistic_kind(male, word)
          words[index] = word
        end
      end
      result = words.join(' ')
    end

    result
  end

  def linguistic_inflect(word, inflection)
    # Падежи
    cases = {
      :normative => 0,
      :genitive => 1,
      :dative => 2,
      :accusative => 3,
      :instrumental => 4,
      :ablative => 5
    }
    inflections = YandexInflect.inflections(word)
    inflection = cases[inflection] || 0
    inflections[inflection]
  end


  def omniauth_providers
    %w{ odnoklassniki vkontakte facebook twitter yandex facebook }
    %w{ vkontakte facebook yandex mailru google  }
  end
 
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  private 

  def linguistic_kind_cache_lookup(word)
    value = $redis.get(word.to_s)   
    if value.size > 0
      value
    else
      nil
    end
  end

  def linguistic_kind_cache_store(word, value)   
    $redis.set(word, value)
  end
end
