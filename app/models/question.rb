# encoding: utf-8

class Question < ActiveRecord::Base           
  belongs_to :questionnaire    
  has_and_belongs_to_many :collections

  has_many :answers, :dependent => :destroy   
  
  has_many :histories                       
  has_many :missings, :through  => :histories
  
  accepts_nested_attributes_for :answers 
  
  after_save :save_answers     

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
                       :all => [1, 2],
                       :guest => 3 } 
     if missing.user == user
       collection = missing.published ? :all : :initial
     else
       collection = :guest
     end
      
     # TODO: Пропущенные вопросы задавать через день
     query = "id IN (SELECT related_question_id FROM related_questions LEFT JOIN histories ON histories.question_id = related_questions.question_id AND (histories.text = related_questions.answer OR histories.answer_id = related_questions.answer) WHERE histories.missing_id = ? AND histories.user_id = ?) AND id NOT IN (SELECT question_id FROM histories WHERE missing_id = ? AND user_id = ?)"
     questions = Question.where(query, missing.id, user.id, missing.id, user.id).order(:position).limit(limit) if limit.is_a? Integer
     questions = Question.where(query, missing.id, user.id, missing.id, user.id).order(:position) if limit.is_a? Symbol 

     
     if limit == :all 
      questions += Question.where("id NOT IN (SELECT question_id FROM histories WHERE missing_id = ? AND user_id = ?) AND collection_id IN (?)", missing.id, user.id, collection_id[collection]).order(:position)
     elsif questions.size == 0 or questions.size < limit
      questions += Question.where("id NOT IN (SELECT question_id FROM histories WHERE missing_id = ? AND user_id = ?) AND collection_id IN (?)", missing.id, user.id, collection_id[collection]).order(:position).limit(limit)
     end
     
     # Подготавливаем данные
     result = []  
     questions.each do |q| 
       # Пропускаем вопрос регистрации, если пользователь авторизирован
       next if !(user.email =~ /guest/) and q.answer_type == 7
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
    #
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
    	answer["answers_ids"] ||= []
    
        answers = []

        # Если нажали отложить вопрос
    	if question_params["action_type"] == "skip"
    		# Сохраняем запись с пометкой пропущен
    		answers.push History.create({ :missing => missing, 
    								 :question => question,
    								 :user => user,
    								 :text => "skip" 
		   })
	    else
	    	case question.answer_type  
        # Ответ да-нет
    		when 0 
    			answers.push History.create({ :missing => missing, 
    								 :question => question,
    								 :user => user,                         
    								 :answer_id => question.answers.where(:text => question_params["action_type"]).first.id,
    								 :text => question_params["action_type"]
			    })   
			   
         # Один вариант ответа
		    when 1
		    	answers.push History.create({ :missing => missing, 
    								 :question => question,
    								 :user => user,
    								 :text => answer["text"]
			   }) if answer["id"] == "other" and !answer["text"].empty?    
			   
			   answers.push History.create({ :missing => missing, 
     								 :question => question,
     								 :user => user,
     								 :answer_id => answer["id"]
 			   }) unless answer["id"] == "other"
         # Несколько вариантов ответа
		    when 2
		    	answer["answers_ids"].each do |a|
		    	   answers.push History.create({ :missing => missing, 
	    								 :question => question,
	    								 :user => user,
	    								 :answer_id => a.first
				   })
			   end

			   answers.push History.create({ :missing => missing, 
    								 :question => question,
    								 :user => user,
    								 :text => answer["text"]
			   }) unless answer["text"].empty?    
			   
         # Свободное поле
		   when 3
		   	   answers.push History.create({ :missing => missing, 
    								 :question => question,
    								 :user => user,
    								 :text => answer["text"]
			   }) unless answer["text"].empty?      
			   
         # Карта
       when 4
         answer["places"]["geopoint"].each_with_index do |a,index|
           geoPoint = a.split(',') 
           place = Place.create({ :address => answer["places"]["address"][index],
                          :latitude => geoPoint[1],
                          :longitude => geoPoint[0]
           })
            
           answers.push History.create({ :missing => missing, 
     								 :question => question,
     								 :user => user,
     								 :text => place.id
   			   })  
 			   end
		   # Дата
	     when 6
  	     answers.push History.create({ :missing => missing, 
   								 :question => question,
   								 :user => user,
   								 :text => answer["date"]
  		   }) unless answer["date"].empty?         

         # Регистрация
         when 7
           unless answer["name"].empty? || answer["email"].empty?
             new_user = User.create!({ :name => answer["name"],
                            :email => answer["email"],
                            :phone => answer["phone"]
             })           
             answers.push History.create({ :missing => missing,
                             :question => question,
                             :user => user,
                             :text => new_user.id
             }) unless new_user.nil?
              
           end
         end

	   end
	  return answers	
	    
    end
  end 
  
  
  def self.answer_type(value)                 
    return %w[yes_no one many text geo man date][value] if value.is_a? Integer
    return { "yes_no" => 0, "one" => 1, "many" => 2, "text" => 3, "geo" => 4, "man" => 5, "date" => 6 }[value] if value.is_a? String
  end  
  
  private 
  
  def save_answers
    if self.answer_type = 0
      ["yes","no"].each do |answer| 
         Answer.create({ :question_id => self.id, :text => answer }) if self.answers.where({ :text => answer }).empty?
      end                                                     
    end
  end
  
      
end
  
