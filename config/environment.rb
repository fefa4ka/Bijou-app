#or questions.length == 0 or questions.length < limit Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
People::Application.initialize!

# Mailer initialize
ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
   :enable_starttls_auto => true, 
   :address => "smtp.gmail.com",
   :port => 587,
   :tls => true,
   :domain => "naidutebya.ru",
   :authentication => :plain,
   :user_name => "info@naidutebya.ru",
   :password => "gjbcrk.ltqbyaj1",
}
