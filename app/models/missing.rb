# encoding: utf-8

class Missing < ActiveRecord::Base     
  include ApplicationHelper

  # Search index preferences
  define_index do 
    indexes name
    indexes history
    indexes city

    has gender, age, last_seen, latitude, longitude, user_id, published, created_at, updated_at
  end

  is_impressionable
  
  belongs_to :user
  belongs_to :author
  
  has_many :photos, :dependent => :destroy
  has_many :discussions, :dependent => :destroy   
  
  has_many :histories, :dependent => :destroy
  has_many :questions, :through => :histories 
  
  has_many :user_answers
  
  has_many :seen_the_missings

  attr_writer :current_step  

  # Поля характеристик
  attr_accessor :ages
  
  accepts_nested_attributes_for :user
  accepts_nested_attributes_for :author
  accepts_nested_attributes_for :photos, :allow_destroy => true
  
  default_scope :order => "updated_at DESC"
  
  before_save :assign_virtual_variables
                             
  def to_param                 
    name_parameterized = (name && Russian::transliterate(name).gsub(/[^a-z0-9]+/i, '-').downcase) || ""
    "#{id}-#{name_parameterized}/"
  end
                 
  # Name
  def last_name
    name.split(" ")[0] || ""
  end
  
  def second_name
    name.split(" ")[2] || ""
  end

  def first_name
    name.split(" ")[1] || ""
  end

  def short_name
    first_name + ' ' + last_name
  end

  # Возраст
  def age 
    now = Date.today
    now.year - self.birthday.year if self.birthday && self.birthday.is_a?(Date) || nil
  end
  
  # Когда последний раз видели
  def last_seen(user_id=self.user_id)
    if answer = answers({ :question_id => 35 })
      answer.first[:answers].first
    end
  end

  # TODO: Текст истории, не помню где используется. Нужно упразднить или сделать
  def history(user_id=self.user_id)
    ""
  end

  # Люди, которые отвечали на вопросы
  def users_who_answer
    user_ids = self.histories.select("DISTINCT user_id, user_id").collect(&:user_id)
    User.find(user_ids)
  end

  # Характеристики, не помню используются ли где-то
  # Сейчас их заменяет коллекция ответов
  def characteristics(user_id=self.user_id)
    []
  end

  # Места связанные с пропажей
  def places(user_id=self.user_id)
    answers({ :answer_type => 4 }) 
  end

  # Город, где как мы считаем пропал человек
  # Берётся город первого места, связанного с пропажей. 
  # Возможно, в будущем, пересмотрим это решение
  def city(user_id=self.user_id)
    if place = places(user_id)
      place.first[:answers].first[:city]
    end
  end


  # Координаты места пропажи. 
  # Используется для индексирования поиском
  # Как место используется не место пропажи, а первое место из всех. 
  # Сделать так, чтобы выбиралось из мест связанных с пропажей, а если нет то с любого другого.
  def latitude(user_id=self.user_id)
    return nil if places(user_id).nil?

    place = places(user_id).first[:answers].first || nil 
    # Degree to radians
    (place[:latitude] / 180) * Math::PI unless place.nil?
  end

  def longitude(user_id=self.user_id)
    return nil if places(user_id).nil?

    place = places(user_id).first[:answers].first || nil
    # Degree to radians
    (place[:longitude] / 180) * Math::PI unless place.nil?
  end
    
  # Кто может помочь в поисках
  def can_helps   
    # Получаем список людей, которые ответили на вопрос «Чем можете помочь в поисках?»
    users = self.histories.where({ :question_id => 53 }).where("histories.text <> 'skip' OR histories.text IS NULL").select("DISTINCT user_id").select(:user_id).collect(&:user_id) 
    users.each.collect do |user| 
      # Делаем из этого объект. Преобразуем сначала словарь ответа.
      record = Hashie::Mash.new(answers({ :user_id => user, :question_id => 53 }).first) 
      # Добавляем данные про добровольца и про эту пропажу
      record.user = User.find(user)
      record.missing = self
      record.id = "#{record.user_id}#{record.missing_id}#{record.question_id}"
      record
    end
  end

  # Когда последний раз видели
  def last_visit
    @current_user.last_visit("Missing", self.id)
  end
     
  # Коллекция вопросов и ответов
  # Коллекции хранятся в модели Collections
  # По умолчанию публичная коллекция и строится в виде дерева. 
  # TODO: Куда нужно дерево? А куда дерево не нужно?
  def collection(opts={ :collection_name => "public" })
    default_opts={
      :question_id => Collection.where({ :name => opts[:collection_name] }).first.questions.select(:question_id).collect(&:question_id),
      :is_tree => true
    }
    opts = default_opts.merge(opts)

    answers = answers(opts)
    if opts[:is_tree] && !answers.nil?
      collection = {}
      answers.each do |a|
        q_id = a[:questionnaire_id]
        collection[q_id] ||= []
        collection[q_id].push(a)
      end
     
      answers = []
      collection.each do |k,c|
        answers.push( { :id => c.first[:questionnaire_id], :name => c.first[:questionnaire], :questions => c } )
      end
    end
    
    answers
  end

  def answers(opts={})
    default_opts = {
      :answer_type => nil,
      :user_id => self.user_id
    }
    opts = default_opts.merge(opts)

    # Загружаем пользовательские ответы для каждого вопроса    
    array_questions = []
    hash_questions = {}
                 
    conditions = {} 
    conditions = { :histories => { :user_id => opts[:user_id] } } unless opts[:user_id].nil?
    conditions[:answer_type] = opts[:answer_type] unless opts[:answer_type].nil?
    conditions[:id] = opts[:question_id] unless opts[:question_id].nil?
    
    questions = self.questions.where(conditions).where("histories.text <> 'skip' OR histories.text IS NULL").select("DISTINCT question_id, questions.*")

    questions.each do |q|        
      question = hash_questions[q.id] || nil
    
      question = { 
        :questionnaire => (q.questionnaire && q.questionnaire.name) || "",
        :questionnaire_id => (q.questionnaire && q.questionnaire.id)  || "", 
        :question_id => q.id, 
        :text => q.text,
        :label => linguistic_kind(self.gender, q.field_text),  
        :answer_type => q.answer_type,
        :answers => [],
        :human_answer => nil,        
        :human_text => linguistic_kind(self.gender, q.human_text),
        :user_id => opts[:user_id],
        :created_at => q.histories.last.created_at
      } if question.nil?    
      array_questions.push(question) if hash_questions[q.id].nil?

      conditions = { :missing_id => self.id, :question_id => q.id }
      conditions[:user_id] = opts[:user_id] unless opts[:user_id].nil?
      #user_answers = q.answer_type != 4 ? History.where(conditions).where("histories.text <> 'skip' OR histories.text IS NULL").group(:answer_id) : History.where(conditions).where("histories.text <> 'skip' OR histories.text IS NULL")
      user_answers = History.where(conditions).where("histories.text <> 'skip' OR histories.text IS NULL")
         
      user_answers.each do |a|  
        answer = human_answer = a.answer.nil? ? a.text : a.answer.human_text || a.text || a.answer.text
        
        case q.answer_type
          # Несколько вариантов ответа
        when 2             
          human_answer = question[:human_answer].to_s + ", #{human_answer}" if question[:answers].size > 0           
        # Карты
        when 4
          place = Place.find(answer.to_i)
          
          answer = { 
            :address  => place.address,
            :country  => place.country,
            :state    => place.state,
            :city     => (place.city rescue nil),   # TODO: Доделать геокодер, чтобы правильно определялся город и добавить кеширование.
            :street   => place.street,              # С кешированием
            :latitude => place.latitude,
            :longitude => place.longitude 
          } unless place.nil?   
          
          question[:human_text] = (question[:human_text] || "").mb_chars.capitalize.to_s
          question[:human_text] = question[:human_text].gsub("#city", YandexInflect.inflections(answer[:city] || answer[:address] || answer[:country]).last).gsub("#address", YandexInflect.inflections(answer[:street] || "").second)
        
        when 6
          answer = Date.parse(a.text)
          human_answer = Russian.strftime(answer, "%e %B %Y")   
        end 
        
        question[:human_answer] = linguistic_kind(self.gender, human_answer.mb_chars.capitalize.to_s)
        question[:answers].push(answer)
          
      end    
      
      hash_questions[q.id] = question
    end    
    
    array_questions.size > 0 ? array_questions : nil
  end

  # Steps methods
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
           
  def steps
    %w[common history contacts]
  end     
  private               
   

  def assign_virtual_variables
    self.city = city
    self.history = history
    self.age = age
    self.last_seen = last_seen
    self.latitude = latitude
    self.longitude = longitude
  end
end                                
