class Missing < ActiveRecord::Base         
  is_impressionable
  
  belongs_to :user
  
  has_many :photos, :dependent => :destroy
  has_many :discussions, :dependent => :destroy   
  
  has_many :histories, :dependent => :destroy
  has_many :questions, :through => :histories
  
  has_many :user_answers
  
  has_many :can_helps 

  attr_writer :current_step  

  # Поля характеристик
  attr_accessor :man_age,
                :author_callback_phone, :author_callback_email, :private_history, :private_contacts, :photos_attributes, :author_name, :author_email, :author_phone, :author_callback_email, :author_callback_phone, :author_callback_hash, :missing_password
  
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :photos

 
  
                            
  # typograf :decription, :use_p => true, :use_br => true, :encoding => "UTF-8"
  
  after_find :prepare_data                                                                                
  
  default_scope :order => "updated_at DESC"
                             
  def to_param                 
    "#{id}-#{name.parameterize}/"
  end
                 
  def last_visit
    @current_user.last_visit("Missing", self.id)
  end
     
  def history(user_id=self.user_id)
    ""
  end
  
  def characteristics(user_id=self.user_id)
    []
  end

  def places(user_id=self.user_id)
    answers(4, user_id)
  end

  def answers(answer_type=nil, user_id=self.user_id)
    # Загружаем пользовательские ответы для каждого вопроса    
    array_questions = [] 
    hash_questions = {} 
    
    questions = self.questions.where("user_id = ? AND answer_type = ?", user_id, answer_type).select("DISTINCT question_id, questions.*") unless answer_type.nil?
    questions = self.questions.where("answer_type IS NOT NULL AND user_id = ?", user_id).select("DISTINCT question_id, questions.*") if answer_type.nil?
    
    questions.each do |q|        
      question = hash_questions[q.id] || nil
    
      question = { 
        :questionnaire => q.questionnaire.name || "",
        :id => q.id, 
        :text => q.text,
        :label => q.field_text,  
        :answer_type => q.answer_type,
        :answers => [],
        :human_answer => nil 
      } if question.nil?    
      array_questions.push(question) if hash_questions[q.id].nil?


      user_answers = History.where( :missing_id => self.id, :question_id => q.id, :user_id => user_id )
          
      user_answers.each do |a|  
        answer = human_answer = a.answer.nil? ? a.text : a.answer.human_text || a.text || a.answer.text
        
        case q.answer_type
          # Несколько вариантов ответа
        when 2             
          human_answer = question[:human_answer].to_s + ", #{human_answer}" if question[:answers].size > 0
        
        # Карты
        when 4
          place = Place.find(answer.to_i)
          
          human_answer = "" 
          answer = { 
            :address => place.address,
            :latitude => place.latitude,
            :logitude => place.longitude 
          } unless place.nil?   
        
        when 6
          answer = Date.parse(a.text)
          human_answer = Russian.strftime(answer, "%e %B %Y")
        end 
        
        question[:human_answer] = human_answer
        question[:answers].push(answer)
          
      end                           
      
      hash_questions[q.id] = question
    end    
    
    array_questions
  end

  def current_step
    @current_step || steps.first
  end                                                                                                                                 
                                                          
  def next_step
    next_step = steps[steps.index(current_step)+1] || ""
  end
  
  def previous_step
    previous_step = steps[steps.index(current_step)-1] || ""
  end
  
  def first_step?
    current_step == steps.first
  end
  
  def last_step?
    current_step == steps.last
  end            
       
  private               
   def steps
      %w[common history contacts]
    end
    
    def prepare_data
      now = Date.today
      self.man_age = now.year - self.birthday.year if self.birthday.is_a?(Date)       
    end  
end                                
