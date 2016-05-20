require 'socket'

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

		self.add
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

		add
	end

	def add
		@@clientes << self
	end

end

class Administrador < Funcionario
	@@administradores = []
	def initialize(nome, rg, senha)
		puts "-"*10
		puts "Administrador: #{ nome }"
		puts "RG: #{rg}"
		puts "Senha: #{ "*"*senha.size }"

		self.add
	end

	
	def add
		@@administradores << self
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
					Funcionario.new(nome.chomp, rg.chomp, senha.chomp)
				else
					Administrador.new(nome.chomp, rg.chomp, senha.chomp)
				end
			elsif line.chomp == "Cliente"
				nome = f.gets
				rg = f.gets
				senha = f.gets
				cc = f.gets
				cp = f.gets
				scc = f.gets
				scp = f.gets
				Cliente.new(nome.to_s.chomp, rg.to_s.chomp, senha.to_s.chomp, cc.to_s.chomp, cp.to_s.chomp, scc.to_s.chomp, scp.to_s.chomp)
			else
				puts line.chomp
			end
		end
	end
rescue
	puts "Erro na leitura do banco de dados"
	exit
end

 # Iniciando o Servidor

loop {
	begin
		erro
	rescue
		puts "Erro no servidor. Reiniciar o servidor? (Y/N)?"
		resposta  = gets.chomp
		if not (resposta[0] == "Y" or resposta[0] == "y")
			break
		end
	end
}
