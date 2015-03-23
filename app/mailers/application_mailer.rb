class ApplicationMailer < ActionMailer::Base
  default from: "from@example.com"
  # to style for email -- create mailer layout in views/layouts
  # layout 'mailer'
end

# preview at => 
# http://localhost:3000/rails/mailers/donation_mailer
# see test/mailers/previews for syntax to preview via rails s