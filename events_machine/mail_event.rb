 require 'eventmachine'
  module EchoServer  

    def generate_email(email_credential)
      email = EM::Protocols::SmtpClient.send(
                :domain=>"stackflow.com",
                :host => "localhost",
                :port => 1025,
                :from=> email_credential[:from],
                :to=> email_credential[:to],
                :body => email_credential[:body],
                :header=> {"Subject" => email_credential[:subject] }
              )
      email.callback {
        puts 'Email sent!'
      }
      email.errback { |e|
        puts "email failed #{e}"
      }
    end
  end
 
 



