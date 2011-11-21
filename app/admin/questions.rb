ActiveAdmin.register Question do   
  index do
    column :text
    column "Answers" do |question|
      (question.answers.map{ |a| a.text }).join(', ')
    end
  end

  form do |f|
    f.inputs do
      f.input :text
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
