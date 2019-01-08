require "#{Rails.root}/events_machine/mail_event"
# include EchoServer

Thread.new { EventMachine.run do
              EventMachine.start_server("127.0.0.1", 3002, EchoServer) 
              end
            }
