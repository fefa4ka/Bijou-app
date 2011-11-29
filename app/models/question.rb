class Question < ActiveRecord::Base        
  has_many :answers
  has_many :related_questions
  
  accepts_nested_attributes_for :answers      
  
  def self.for(missing, user) 
     # Для каждого человека новый набор вопросов
     
     # Если объявление на этапе создания (не опубликованно), то выдается первй блок вопросов
     # Этап создания - объявление не опубликованно, учетка не создана.
     
     # Если совсем не отвечали на вопрос, выбирается первый из списка по position
     
     # Если отвечал уже, то ищем сначала связанные с ответами вопросы (не отвеченные).
     # Потом ищем следующие по порядку неотвеченные вопросы из общего списка.
     
     # Выдаем в формате
     # question = {                                       
     #        id,
     #        text,     
     #        type = ['one', 'any', 'map', 'man', 'text'],     
     #        additional_field = true/false,
     #        answers = ['example 1', 'example 2', 'example 3']
     #      }  
  end               
  
  def self.answer(question, answer, missing, user)    
    # Для разных типов вопросов свои обработчики:
    #       one, text - сохраняет один вариант
    #       any - сохраняет несколько вариантов
    #       map - сохраняет в places
    #       man - сохраняет в familiars          
    
    # Определяем тип вопроса и передаем в нужный обработчик      
  end  
  
end
  
