require 'socket'

module Datas
	class Funcionario
		@nome
		@rg
		@senha
		@@funcionarios = []
		def initialize(nome, rg, senha)
			puts "-"*10
			puts "Funcionario: #{ nome }"
			puts "RG: #{rg}"
			puts "Senha: #{ "*"*senha.size }"

			@nome = nome
			@rg = rg
			@senha = senha

			self.add
		end

		def pegarDados
			return @nome, @rg, @senha;
		end

		def self.funcionarios
			return @@funcionarios
		end
		
		def add
			@@funcionarios << self
		end
		
	end

	class Cliente
		@nome
		@rg
		@senha
		@cc
		@cp
		@scc
		@scp
		@@clientes = []
		def initialize(nome,rg,senha,cc,cp,scc,scp)
			puts "-"*10
			puts "Cliente: #{ nome }"
			puts "RG: #{rg}"
			puts "Senha: #{"*"*senha.size}"
			puts "Conta C. : #{cc}"
			puts "\t R$ #{scc}"
			puts "Conta P. : #{cp}"
			puts "\t R$ #{scp}"

			@nome = nome
			@rg = rg
			@senha = senha
			@cc = cc
			@cp = cp
			@scc = scc
			@scp = scp

			add
		end

		def add
			@@clientes << self
		end
		
		def pegarDados
			return @nome, @rg, @senha, @cc, @cp, @scc, @scp
		end

		
		def self.clientes
			return @@clientes
		end	

		def self.verifica usr, snh
			copy = @@clientes
			puts "Iniciando verificacao"
			for i in copy
				nome,rg,senha,cc,cp,scc,scp = i.pegarDados
				puts "#{nome} - #{senha}"
				if nome == usr and senha == snh
					return true
				end
			end
			return false
		end

		def self.pegarCliente name
			copy = @@clientes
			
			for i in copy
				nome, rg, senha, cc, cp, scc, scp = i.pegarDados
				if nome == name
					return i
				end
			end
		end

	end

	class Administrador < Funcionario
		@@administradores = []
		def initialize(nome, rg, senha)
			puts "-"*10
			puts "Administrador: #{ nome }"
			puts "RG: #{rg}"
			puts "Senha: #{ "*"*senha.size }"

			@nome = nome
			@rg = rg
			@senha = senha

			self.add
		end
		
		def pegarDados
			return @nome, @rg, @senha
		end
		
		def add
			@@administradores << self
		end

		def self.administradores
			return @@administradores
		end
	end
end

module Network
	class User
		def initialize tcp
			@tcp = tcp
			@domain,@remote,@host,@ip = tcp.peeraddr
			@thread = Thread.new {
				self.work
			}

			puts "#{@ip} se conectou"
		end

		def work
			# O network funciona neste método
			begin
				loop{
					command = @tcp.gets.chomp
					if command == "client login"
						usuario = @tcp.gets.chomp
						senha = @tcp.gets.chomp

						@tcp.puts(Datas::Cliente.verifica(usuario, senha))
					end

					if command == "getinfo"
						usuario = @tcp.gets.chomp
						senha = @tcp.gets.chomp
						puts "Buscando informacoes"
						if Datas::Cliente.verifica(usuario, senha)
							cliente = Datas::Cliente.pegarCliente(usuario)
							puts "#{cliente} encontrado"
							nome, rg, senha, cc, cp, scc, scp = cliente.pegarDados
							@tcp.puts nome
							@tcp.puts rg
							@tcp.puts cc
							@tcp.puts cp
							@tcp.puts scc
							@tcp.puts scp
						end
					end
				}
			rescue => e
				puts "Erro com o cliente: #{e}"
				self.close 	
			end
		end

		def close
           @tcp.close
           @thread.kill
		end
	end
end

 # Iniciando o Banco de Dados

begin
	File.open('dados.txt', 'r') do |f|
		while line = f.gets
			if line.chomp == "Funcionario" || line.chomp == "Administrador"
				nome = f.gets
				rg = f.gets
				senha = f.gets
				if line.chomp == "Funcionario"
					Datas::Funcionario.new(nome.chomp, rg.chomp, senha.chomp)
				else
					Datas::Administrador.new(nome.chomp, rg.chomp, senha.chomp)
				end
			elsif line.chomp == "Cliente"
				nome = f.gets
				rg = f.gets
				senha = f.gets
				cc = f.gets
				cp = f.gets
				scc = f.gets
				scp = f.gets
				Datas::Cliente.new(nome.to_s.chomp, rg.to_s.chomp, senha.to_s.chomp, cc.to_s.chomp, cp.to_s.chomp, scc.to_s.chomp, scp.to_s.chomp)
			else
				puts line.chomp
			end
		end
	end
rescue => e
	puts "Error: #{e.to_s}"
	puts "Erro na leitura do banco de dados"
	exit
end

 # Iniciando o Servidor

require 'socket'
require 'timeout'
loop {
	begin
		tcp = TCPServer.new 3031
		txt = ""
		thread = Thread.new {
			txt = gets
		}
		loop {
			if txt.chomp == "exit"
				raise "Exit from server"
			end
			puts "Aguardando User"
			begin
				Timeout.timeout (25) {
					Network::User.new(tcp.accept)
				}
			rescue
				puts "Timeout"
			end
		}
	rescue => e
		puts "Error: #{e.to_s}"
		puts "Erro no servidor. Reiniciar o servidor? (Y/N)?"
		resposta  = gets.chomp
		if not (resposta[0] == "Y" or resposta[0] == "y")
			break
		end
	end
}

 # Salvando dados do Servidor

begin

	File.open("dadosteste.txt", "w") do |f|
		admins = Datas::Administrador.administradores
		for i in admins
			nome, rg, senha = i.pegarDados
			f.puts "Administrador"
			f.puts nome.chomp
			f.puts rg.chomp
			f.puts senha.chomp
			f.puts " "
		end

		funcionarios = Datas::Funcionario.funcionarios
		for i in funcionarios
			nome,rg,senha = i.pegarDados
			f.puts "Funcionario"
			f.puts nome.chomp
			f.puts rg.chomp
			f.puts senha.chomp
			f.puts " "
		end
		
		clientes = Datas::Cliente.clientes
		for i in clientes
			nome,rg,senha,cc,cp,scc,scp = i.pegarDados
			f.puts "Cliente"
			f.puts nome.chomp
			f.puts rg.chomp
			f.puts senha.chomp
			f.puts cc.chomp
			f.puts cp.chomp
			f.puts scc.chomp
			f.puts scp.chomp
		end
	end
	

rescue => e
	puts "Erro: #{e.to_s}"
	puts "Erro na gravacao do Banco de Dados"

end
