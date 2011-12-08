ActiveAdmin.register Question do   
  index do
    column :text  
    column :answer_type
    column "Answers" do |question|
      (question.answers.map{ |a| a.text }).join(', ')
    end             
    default_actions
  end

  form do |f|
    f.inputs do
      f.input :collection_id, :as => :select, :collection => { "При регистрации" => 1, "Остальные вопросы для автора" => 2, "Для посетителей" => 3 }                              
      f.input :questionnaire, :as => :select
      f.input :text     
      f.input :answer_type, :as => :select, :collection => { "Да-Нет" => 0, "Один вариант" => 1, "Несколько вариантов" => 2, "Свободное поле" => 3, "Карта" => 4, "Описание человека" => 5, "Дата и время" => 6 }
      f.input :other, :as => :radio, :label => "С другим вариантом"
      f.has_many :answers do |a|
        a.input :text    
      end
    end
    f.buttons
  end

  show do
    div :class => 'panel' do
      h3 'Question'
      div :class => 'panel_contents' do
        div :class => 'attributes_table user' do
          table do
            tr do
              th { 'Question' }
              td { question.text }
            end
            tr do
              th { 'Answers' }
              td { (question.answers.map { |a| a.text }).join(', ') }
            end
          end # table
        end # attributes_table
      end # panel_contents
    end # panel
  end # show
end
