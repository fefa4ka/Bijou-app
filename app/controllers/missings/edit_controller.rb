# encoding: utf-8

require 'digest/md5'
require 'net/http'

class Missings::EditController < Missings::ApplicationController
    
  def answer_the_question
    question_params = params["question"]
    missing = Missing.find(params[:id])
    user = current_or_guest_user
    
    answers = Question.answer question_params, missing, user
    # Логиним, если вопрос "Как с вами связаться?"
    if answers.size == 1 && answers.first.question.answer_type == 7
      user = User.find(answers.first.text)
      sign_in user
    end
    next_question = Question.for(missing, user, 3).first
    
    if next_question.nil?
      History.where({ :missing_id => missing.id, :user_id => user.id, :text => "skip" }).each { |h| h.destroy }
    end
    
    respond_to do |format|
      format.json {
        render :json => {
          :ok => true,
          :logged_in => user_signed_in?,
          :question => next_question,    
          :questions_count => Question.for(missing, current_or_guest_user, :all).size
        }
      } 
    end                            
  end

  # PUT /missings/1
  # PUT /missings/1.xml
  def update
    @missing = Missing.find(params[:id])

    respond_to do |format|
      if @missing.update_attributes(params[:missing])
        format.html { redirect_to(@missing, :notice => 'Missing was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @missing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /missings/1
  # DELETE /missings/1.xml
  def destroy
    @missing = Missing.find(params[:id])
    @missing.destroy

    respond_to do |format|
      format.html { redirect_to(missings_url) }
      format.xml  { head :ok }
    end
  end


  def i_seen_the_missing
    seen_params = params[:seen_the_missing]
    seen = SeenTheMissing.where({ :missing_id => seen_params[:missing_id], :user_id => current_or_guest_user })
    
    if seen.size == 0
      seen = SeenTheMissing.new seen_params
      seen.user = current_or_guest_user
    else
      seen = seen.first
      seen.update_attributes seen_params
    end

    if seen.save
      respond_to do |format|
        format.json { 
          render :json => { :ok => true } 
        }
      end
    end
  end

    # Add comment
  def add_comment                                             
    params[:discussion]["user_id"] = current_user.id
    
    @missing = Missing.find(params[:discussion]["missing_id"])
    @comment = Discussion.new(params[:discussion])       
    @comment.save           
     
    expire_fragment(:controller => 'missings', :action => 'show', :action_suffix => 'missing_comments', :id => @missing.id)
    
    if @comment.user.nil?
      @comment.user = {
        :id => 0,
        :username => "Анонимный комментарий" 
      }          
    end
    
    
    data = {
      :comment => @comment.comment,    
      :discussion_id => @comment.discussion_id,
      :date => Russian.strftime(@comment.created_at, "%d %B"), 
      :user => {
        :id => @comment.user.id,
        :username => @comment.user.name
      }
    }                                                         

    
    respond_to do |format| 
      format.json {
        render :json => { :ok => "true", :comment => data } 
      }           
    end
  end
    

end
