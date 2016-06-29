require 'Fleyhe' 	#gem install Fleyhe

class MainEvent < Fleyhe::Network::Event; end

class Log < MainEvent

	# Args:
	#  0 - name
	#  1 - password

	# Form:
	#  n - Lines

	def solve
		auth = EDA::Funcionario.new @args[0], @args[1]
		if auth.autenticar
			@event = 'Log'
			@form = EDA::Log.getLog

		else
			@event = 'error'
		end
	end

end

class LogarFunc < MainEvent

	# Args:
	#  0 - name
	#  1 - password

	# Event
	#  ok - Login sucess
	#  error - fail on login

	def solve
		auth = EDA::Funcionario.new @args[0], @args[1]
		puts @args.to_s
		if auth.autenticar
			@event = "ok"
		else
			@event = "error"
		end
	end

end

class CriarCliente < MainEvent

	# Args:
	# 0 - name
	# 1 - cc
	# 2 - cp
	# 3 - password

	def solve

		query = $db.execute "SELECT * FROM Cliente WHERE nome = '#{@args[0].chomp}'"
		puts query
		if (query.size > 0)
			@event = "error"
			@args[0] = "name"
			return
		end

		query = $db.execute "SELECT * FROM Cliente WHERE cc = '#{@args[1].chomp}'"
		puts query
		if (query.size > 0)
			@event = "error"
			@args[0] = "cc"
			return
		end

		query = $db.execute "SELECT * FROM Cliente WHERE cp = '#{@args[2].chomp}'"
		puts query
		if (query.size > 0)
			@event = "error"
			@args[0] = "cp"
			return
		end

		query = $db.execute "INSERT INTO Cliente (nome, cc, cp, senha) VALUES ('#{@args[0].chomp}','#{@args[1].chomp}','#{@args[2].chomp}','#{@args[3].chomp}')"
		puts query

		@event = "ok"

		EDA::Log.createLog("Usuário #{@args[0].chomp} criado");

	end
end

class RemoverCorrente < MainEvent
	def solve
		@event = "fail"
		@args[0].chomp!
		@args[1] = @args[1].chomp!.to_f

		query = $db.execute("SELECT scc FROM Cliente WHERE cc = '#{@args[0]}'")
		if (query[0]['scc'] > @args[1])
			$db.execute("UPDATE Cliente SET scc = scc - #{@args[1]} WHERE cc = '#{@args[0]}' ")
			@event = "ok"
		end
	end
end

class RemoverPoup < MainEvent
	def solve
		@event = "fail"
		@args[0].chomp!
		@args[1] = @args[1].chomp!.to_f

		query = $db.execute("SELECT scc FROM Cliente WHERE cc = '#{@args[0]}'")
		if (query[0]['scc'] > @args[1])
			$db.execute("UPDATE Cliente SET scc = scc - #{@args[1]} WHERE cc = '#{@args[0]}' ")
			@event = "ok"
		end
	end
end

class AumentarPoup < MainEvent
	def solve
		@event = "fail"
		@args[0].chomp!
		@args[1] = @args[1].chomp!.to_f

		$db.execute("UPDATE Cliente SET scp = scp + #{@args[1]} WHERE cp = '#{@args[0]}' ")
		@event = "ok"
	end
end

class AumentarCorrente < MainEvent
	def solve
		@event = "fail"
		@args[0].chomp!
		@args[1] = @args[1].chomp!.to_f

		$db.execute("UPDATE Cliente SET scp = scp + #{@args[1]} WHERE cp = '#{@args[0]}' ")
		@event = "ok"
	end
end

class UpdateFuncionario < MainEvent
	# Args:
	# 0 - Nome
	# 1 - Senha
	# 2 - Admin
	# 3 - NomeADM
	# 4 - SenhaADM

	def solve
		@args[0].chomp!
		@args[1].chomp!
		@args[2].chomp!
		@args[3].chomp!
		@args[4].chomp!

		func = Funcionario.new @args[3], @args[4]
		
		if func.admin?
			return
		end
		
	end
end

class Extrato < MainEvent
	def solve
		cc @args[0].to_i
	end
end

class Saque < MainEvent
	# 0 = conta
	# 1 = valor
	# 2 = poupança = t
	# 3 = senha
	def solve
	puts @args
		@event = "fail"	
		@form[1] = "ok"
		if @args[2].chomp == "t"
			t = true
		else
			t = false
		end
		cliente = EDA::Cliente.new @args[0].chomp, @args[3].chomp
		if cliente.autenticado?
			# ver saldo
			if t
				coluna = "scp"
				colunac = "cp"
			else
				coluna = "scc"
				colunac = "cc"
			end

			query = $db.execute "SELECT #{coluna} FROM Cliente WHERE #{colunac} = '#{@args[0].to_s.chomp}'"
			puts query[0][0].to_f
			puts query[0][0]
			unless query[0][0].to_f < @args[1].to_f
				@event = "fail"
			end

			puts $db.execute "UPDATE Cliente SET #{coluna} = #{coluna} - #{@args[1].to_f} WHERE #{colunac} = '#{@args[0].to_s.chomp}'"

			@event = "ok"
		end

		
	end
end

class ConfirmJuros < MainEvent
	def solve
		query = $db.execute "UPDATE Cliente SET scp = scp + scp*juros"
		EDA::Log.createLog("Juros atualizado")
		@event = "ok"
		@form[0] = "atualizado"
	end

end


module EDA

	class Funcionario

		def initialize login, password

			@nome = login
			@senha = password

		end

		def admin?
			query = $db.execute "SELECT admin FROM Funcionario WHERE nome = '#{@nome}'"
			if query[0].to_i == 1
				return true;
			end
			return false;

		end

		def autenticar
			a = $db.execute "SELECT senha FROM Funcionario WHERE nome = '#{@nome.to_s.chomp}'"

			if a[0]['senha'] == @senha.chomp
				return true

			else
				return false
			end
		end

	end

	class Log
		def self.getLog
			registros = $db.execute "SELECT * FROM Log"

			ret = []
			for i in registros
				ret << "#{i['data']}: #{i['descricao']}"
			end

			return ret

		end

		def self.createLog desc, conta=nil
			if conta == nil
				$db.execute "INSERT INTO log (data,descricao) VALUES ('#{Time.now.gmtime}', '#{desc}')"
			else
				$db.execute "INSERT INTO log (data,descricao,conta) VALUES ('#{Time.now.gmtime}', '#{desc}', '#{conta}')"
			end
		end
	end

	class Cliente
		def initialize conta, senha, p = true
			if p
				@cPoup = conta
				@conta = conta
			else
				@cCorr = conta
				@conta = conta
			end
			@p = p
			@senha = senha
		end

		def autenticado?
			#verificar login e senha
			if @p
				query = $db.execute "SELECT senha FROM Cliente WHERE cp = '#{@cPoup.to_s.chomp}'"
			else
				query = $db.execute "SELECT senha FROM Cliente WHERE cc = '#{@cCorr.to_s.chomp}'"
			end

			if query[0]['senha'].to_s.chomp == @senha.to_s.chomp
				return true
			end
			return false
		end
	end

end


$db = Fleyhe::Data::Database.new "database.db"
$listener = Fleyhe::Network::Listener.new 3030, MainEvent

loop {

	puts Time.now
	sleep 60

}