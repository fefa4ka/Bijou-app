# encoding: utf-8

class UserMailer < ActionMailer::Base
  default from: "Найду тебя <info@naidutebya.ru>"

  def new_missing_email(missing, password=nil)
    @user = missing.user
    @password = password
    @missing = missing
    @url = missing_url(missing)

    mail(:to => @user.email, :subject => "missing.name теперь в розыске")
  end

  def new_message_email(message)
    destionation_user = ( message.destination_user_id && User.find(message.destination_user_id) ) || nil
    parent_message = Message.find(message.message_id) if message.message_id

    @sender = { :email => (message.user && message.user.email) || message.email, 
                :name => (message.user && message.user.name) || message.name,
                :phone => (message.user && message.user.phone) || message.phone
              }

    @destination = { :email => (destination_user && destination_user.email) || parent_message.email,
                     :user => (destination_user && destination_user.name) || parent_message.name,
                     :phone => (destination_user && destination_user.phone) || parent_message.phone }

    mail(:to => @destination[:email], :subject => "Личное сообщение от #{YandexInflect.inflections(@sender[:email])}")
  end
end
