class MessagesController < ApplicationController
  
  before_filter :set_user
  
  def index
    if params[:mailbox] == "sent"
      @messages = @user.sent_messages
    else
      @messages = @user.received_messages
    end
  end
  
  def show
    @message = Message.read(params[:id], current_user)
  end
  
  def new
    @message = Message.new

    if params[:reply_to]
      @reply_to = @user.received_messages.find(params[:reply_to])
      unless @reply_to.nil?
        @message.to = @reply_to.sender.login
        @message.subject = "Re: #{@reply_to.subject}"
        @message.body = "\n\n*Original message*\n\n #{@reply_to.body}"
      end
    end
  end
  
  def create
    @message = Message.new(params[:message])
    @message.sender = @user                    
    @message.recipient = User.find(params[:message][:to])

    if !params[:message][:to_message].nil?
      @message.message_id = params[:message][:to_message]
    elsif !params[:message][:to_seen_the_missing].nil?
      @message.recipient = SeenTheMissing.find(params[:message][:to_seen_the_missing]).user
      @message.seen_the_missing_id = params[:message][:to_seen_the_missing]
    end

    if @message.save
      data =  {
        :text => @message.body,
        :message_id => @message.message_id, 
        :seen_the_missing_id => @message.seen_the_missing_id,
        :date => Russian.strftime(@message.created_at, "%d %B"),
        :user => {
          :id => @user.id,
          :name => @user.name
        }
      }
      render :json => { :ok => "true", :message => data }
    else
      render :json => { :error => "true" }
    end
  end
  
  def delete_selected
    if request.post?
      if params[:delete]
        params[:delete].each { |id|
          @message = Message.find(:first, :conditions => ["messages.id = ? AND (sender_id = ? OR recipient_id = ?)", id, @user, @user])
          @message.mark_deleted(@user) unless @message.nil?
        }
        flash[:notice] = "Messages deleted"
      end
      redirect_to user_message_path(@user, @messages)
    end
  end
  
  private
    def set_user
      if params[:user_id]
        @user = User.find(params[:user_id])
      else
        @user = current_user || User.find_by_email(params[:message]["email"])
        @user = User.new({ :name => params[:message]["name"],
                           :email => params[:message]["email"],
                           :photo => params[:message]["photo"]
        }) if @user.nil?
      end
    end
end
