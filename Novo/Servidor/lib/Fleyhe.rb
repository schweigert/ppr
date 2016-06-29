require 'socket'
require 'thread'
require 'timeout'
require 'sqlite3'


# Made with love <3 by:
#                       Marlon Henry Schweigert

module Fleyhe

    module Network
        

        # Accept Bridges in the server, and configure it
        class Listener
            
            def initialize port=3030,event=Event
                # Config the event
                @event = event
                @event.generateHash
                
                
                # Config the TCPServer
                @tcp = TCPServer.new port
                
                #Config the thread for working
                @thread = Thread.new {
                    self.work
                }
            end
            
            def close
                @thread.kill
                @tcp.close
            end
            
            protected
            def work
                loop {
                    Bridge.new(@tcp.accept, @event)
                    sleep 1
                }
            end
            
            
            
        end
        
        # Made a bridge (Server <-> Client) in TCP to call Events
        class Bridge
        
            def initialize tcp, event=Event
                @tcp = tcp
                @event = event
                @thread = Thread.new {
                    self.work
                }
            end
            
            def close
                # Close your work
                @tcp.close
                @thread.kill
            end
            
            def call event="Event",args=[]
                @tcp.puts event.to_s
                @tcp.puts args.size.to_s
                
                for i in args
                    @tcp.puts i.to_s
                end
                
            end
            
            def read
                event = nil
                args = []
                
                event = @tcp.gets.to_s.chomp
                n = @tcp.gets.to_i
                
                n.times do
                    args << @tcp.gets.to_s
                end
                
                return event,args
                
                
            end
            
            protected
            def work
            
               begin
                    loop {
                        event = nil
                        args = []
                        
                        Timeout.timeout(60) {event, args = self.read}
                        @event.getHash[event].new(self,args)
                        
                    }    
               rescue => e
                    puts "Error on Bridge: #{ self.to_s }"
                    puts " \t #{ e.to_s }"
                    self.close
               end
               
            end
            
        
        end
        

        # Make and generate events for Bridges
        class Event
        
            def initialize bridge, args
                
                @bridge = bridge
                @args = args
                @event = nil
                @form = []
                
                self.solve
                
                unless @event == nil
                    @bridge.call(@event, @form)
                end
                
            end
            
            def solve
                puts "Noting here..."
            end
            
            def self.generateHash
                @@hash = Hash.new
		        obj = ObjectSpace.each_object(Class).select { |klass| klass < self }
		        for i in obj
		                @@hash[i.to_s] = i
		        end
            end
            
            def self.getHash
                return @@hash
            end
        
        end
        
    end

    module Data
        
        class Database
            def initialize file
                @database = SQLite3::Database.open file
                @database.results_as_hash = true
            end

            def execute command
                return @database.execute command
            end

            def close
                @database.close
            end
        end

    end


end
