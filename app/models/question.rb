# encoding: utf-8

class Question < ActiveRecord::Base           
  belongs_to :questionnaire
  has_many :answers, :dependent => :destroy
  
  accepts_nested_attributes_for :answers      
  
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
     #        questionnaire,
     #        text,     
     #        answer_type = ['one', 'any', 'map', 'man', 'text'],     
     #        other = true/false,
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
      
     # TODO: Пропущенные вопросы задавать через день
     questions = Question.where("id IN (SELECT related_question_id FROM related_questions LEFT JOIN missings_histories USING (question_id, answer) WHERE missings_histories.missing_id = ? AND missings_histories.user_id = ?) AND id NOT IN (SELECT question_id FROM missings_histories WHERE missing_id = ? AND user_id = ?)", missing.id, user.id, missing.id, user.id).order(:position).limit(limit)     
     
     if questions.length == 0 or limit == :all or questions.length < limit
       questions += Question.where("id NOT IN (SELECT question_id FROM missings_histories WHERE missing_id = ? AND user_id = ?) AND collection_id = ?", missing.id, user.id, collection_id[collection]).order(:position).limit(limit)
     end
     
     # Подготавливаем данные
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
                    :questionnaire => q.questionnaire.nil? ? "" : q.questionnaire.name,
                    :text => q.text,
                    :answer_type => q.answer_type,
                    :other => q.other,
                    :answers => answers
                  } 
                  
       result.push(question)
     end                   
     
     result
  end               
  
  def self.answer(question_params, missing, user)  
    # question_params = {
    #   id,           
    #   action_type = yes/no/dont_know/skip/answer,
    #   answer = {
    #     text - свободный ответ или другой вариант,
    #     answers_ids = [] - массив с ответами на вопрос с несколькими вариантами
    #     id - ответ на вопрос с одним вариантом
    #   }
    # }  
    # Для разных типов вопросов свои обработчики:
    #       one, text - сохраняет один вариант
    #       any - сохраняет несколько вариантов
    #       map - сохраняет в places
    #       man - сохраняет в familiars          
    
    # Определяем тип вопроса и передаем в нужный обработчик   
    
    # TODO: защита от повторного ответа
    
    # Смотрим, есть ли такой вопрос 
    unless (question = Question.find(question_params["id"])).nil?
    	answer = question_params["answer"] || {}
    	answer["text"] ||= ""
    	                          
    	logger.debug(answer)
    	# Если нажали отложить вопрос
    	if question_params["action_type"] == "skip"
    		# Сохраняем запись с пометкой пропущен
    		MissingsHistory.create({ :missing => missing, 
    								 :question => question,
    								 :user => user,
    								 :answer => "skip" 
		   })
	    else
	    	case question.answer_type
    		when 0
    			MissingsHistory.create({ :missing => missing, 
    								 :question => question,
    								 :user => user,
    								 :answer => question_params["action_type"]
			   })
		    when 1                        
		    	MissingsHistory.create({ :missing => missing, 
    								 :question => question,
    								 :user => user,
    								 :answer => answer["id"]
			   }) unless answer["id"].is_a? Integer
			   
		    	MissingsHistory.create({ :missing => missing, 
    								 :question => question,
    								 :user => user,
    								 :answer => answer["text"]
			   }) if answer["id"] == "other" and answer["text"].empty?
		    when 2
		    	answer["answers_ids"].each do |a|
		    	   MissingsHistory.create({ :missing => missing, 
	    								 :question => question,
	    								 :user => user,
	    								 :answer => a.first
				   })
			   end

			   MissingsHistory.create({ :missing => missing, 
    								 :question => question,
    								 :user => user,
    								 :answer => answer["text"]
			   }) unless answer["text"].empty?
		   when 3
		   	   MissingsHistory.create({ :missing => missing, 
    								 :question => question,
    								 :user => user,
    								 :answer => answer["text"]
			   }) unless answer["text"].empty?
		   end
	   end
		
	    # Получаем следующий вопрос
	    Question.for(missing, user).first
    end
  end 
  
end
  
