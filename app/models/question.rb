class Question < ActiveRecord::Base           
  belongs_to :questionnaires
  has_many :answers, :dependent => :destroy
  
  accepts_nested_attributes_for :answers      
  
  attr_reader :questionnaire 
  
  def self.for(missing, user, limit = 1)                
     # Для каждого человека новый набор вопросов
                         
     # Если объявление на этапе создания (не опубликованно), то выдается первый блок вопросов    
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
                                                        
     
     # Определяем, какую коллекцию вопросов показывать 
     
     # Айдишники коллекций
     # Такая же настройка есть в admin/questions.rb
     collection_id = { :initial => 1, 
                       :all => 2,
                       :guest => 3 } 
     if missing.user == user
       collection = missing.published ? :all : :initial
     else
       collection = :guest
     end
      
     questions = Question.where("id IN (SELECT related_question_id FROM related_questions LEFT JOIN missings_histories USING (question_id, answer) WHERE missings_histories.missing_id = ? AND missings_histories.user_id = ?)", missing.id, user.id).order(:position).limit(limit)     
     
     if questions.length == 0
       questions = Question.where("id NOT IN (SELECT question_id FROM missings_histories WHERE missing_id = ? AND user_id = ?) AND collection_id = ?", missing.id, user.id, collection_id[collection]).order(:position).limit(limit)
     end
     
     result = []  
     questions.each do |q| 
       answers = []        
       q.answers.each do |a|  
         answer = { 
                    :id => a.id,
                    :text => a.text 
                  }   
                  
         answers.push(answer)
       end
       
       
       question = { 
                    :id => q.id,     
                    :questionnaire => q.questionnaire.nil? ? "" :key => "value",  q.questionnaire.name,
                    :text => q.text,
                    :answer_type => q.answer_type,
                    :other => q.other,
                    :answers => answers
                  } 
                  
       result.push(question)
     end                   
     
     result
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
  
