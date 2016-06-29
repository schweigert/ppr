require 'SuricatoNetwork' 	#gem install SuricatoNetwork -> 1.0.3
require 'sqlite3' 			#gem install sqlite3

class Database
	def self.execute arg
		return @@db.execute arg
	end

	def self.open
		@@db = SQLite3::Database.open "database.db"
		@@db.results_as_hash = true
	end

	def self.close
		@@db.close
	end
end

class Login < SuricatoNetwork::Event
	# @form [0] = Nome
	# @form [1] = Senha

	def solve

		a = Database.execute "SELECT senha FROM Clientes WHERE nome = '#{@form[0].to_s.chomp}'"
		if a[0]['senha'] == @form[1].to_s.chomp
			@event = "Login"

		else
			puts "#{@form[0].chomp} recusou o erro"
			@event = "InvalidLogin"
		end

	
	end
end

# Open Database

Database.open

# Start Network
SuricatoNetwork::Listener.new 3030

loop {

	puts Time.now
	sleep 60

}