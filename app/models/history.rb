class History < ActiveRecord::Base
  belongs_to :question
  belongs_to :user
  belongs_to :answer     
  
  belongs_to :missing
  
  
  def as_json(options={})
    { :question => self.question.text, :answer => self.answer.nil? ? "" : self.answer.text }
  end       
  
  
  # Ответы на вопросы по пропаже от пользователя            
  # Выдает данные в виде массива
  # answer = {
  #   answer_type = [0...6],
  #   text, # field_label из questions - ответ да-нет
  #         # human_text из answer_id или answer если не цифра - один вариант ответа
  #         # field_label: a1.human_text, a2.human_text и answer - для нескольких вариантов
  #         # field_label: answer - для свободного поля  
  #         # field_label
  #   address, # для answer_type = 4
  #   geo_point # для answer_type = 4 
  # }  

  
  def self.answers_for(missing, user, type = :all)                         
 	  answers = type == :all ? missing.histories.find( :conditions => ["user_id = :id", 
 	                                                            { :id => user.id }] ) :
 	                           missing.histories.find( :join => "LEFT JOIN `questions` ON questions.id = question_id", 
 	  								                                          :conditions => ["user_id = :id AND answer_type = :type", 
 	  								                                          { :id => user.id, :type => type }] )
   
	  
  end
end
