require 'tk'
require 'socket'

$tcp = TCPSocket.new "localhost", 3031

module Datas

	class Autenticacao
		def initialize login, senha
			@login = login
			@senha = senha
		end

		def login
			return @login
		end

		def senha
			return @senha
		end

		def getu
			@login
		end

		def getp
			@senha
		end

		def tratar

		end
	end

	class CC
		def initialize

		end
	end

end

root = TkRoot.new {
	title "Caixa Eletronico"
}

$root = root

contaLabel = TkLabel.new (root) {
	text "Conta:"
	pack("padx" => 5, "pady" => 5, "side" => "left")
	grid('row' => 0, 'column' => 0)
}


contaEntry = TkEntry.new (root) {
	pack('padx'=>10, 'pady'=>10, 'side'=>'left')
	grid('row' => 0, 'column' => 1)
}

senhaLabel = TkLabel.new (root) {
	text "Senha:"
	pack("padx" => 5, "pady" => 5, "side" => "left")
	grid('row' => 1, 'column' => 0)
}

senhaEntry = TkEntry.new (root) {
	show '*'
	pack("padx" => 10, "pady" => 10, "side" => "left")
	grid('row' => 1, 'column' => 1)
}

entrarButton = TkButton.new (root) {
	text "Entrar"
	pack("padx" => 10, "pady" => 10, "side" => "left")
	grid('row' => 2, 'column' => 1)
	command "login"
}

$senhaLabelVariable = TkVariable.new
$contaLabelVariable = TkVariable.new

contaEntry.textvariable = $contaLabelVariable
senhaEntry.textvariable = $senhaLabelVariable



def login
	begin
		autenticacao = Datas::Autenticacao.new($contaLabelVariable.value, $senhaLabelVariable.value)
		autenticacao.tratar
		$tcp.puts "client login"
		$tcp.puts autenticacao.getu
		$tcp.puts autenticacao.getp
		if eval($tcp.gets)
			$root.lower
			w_session autenticacao
		else
			Tk::messageBox :message => 'Usuario e senha incorretos'
		end
	rescue => e
		Tk::messageBox :message => e.to_s
	end
end

def w_session autenticacao

	$tcp.puts "getinfo"
	$tcp.puts "#{autenticacao.getu}"
	$tcp.puts "#{autenticacao.getp}"

	nome = $tcp.gets.to_s.chomp
	rg = $tcp.gets.to_s.chomp
	cc = $tcp.gets.to_s.chomp
	cp = $tcp.gets.to_s.chomp
	scc = $tcp.gets.to_s.chomp.to_f
	scp = $tcp.gets.to_s.chomp.to_f


	$session = TkToplevel.new {title "Caixa Eletronico 24h"}

	TkButton.new ($session) {
		text "Deposito - Conta Corrente"
		pack("padx" => 50, "pady" => 50, "side" => "left")
		grid('row' => 1, 'column' => 0)
	}


	TkButton.new ($session) {
		text "Deposito - Conta Poupansa"
		pack("padx" => 50, "pady" => 50, "side" => "left")
		grid('row' => 1, 'column' => 1)
	}


	TkButton.new ($session) {
		text "Saque - Conta Corrente"
		pack("padx" => 50, "pady" => 50, "side" => "left")
		grid('row' => 2, 'column' => 0)
	}

	TkButton.new ($session) {
		text "Saque - Conta Poupansa"
		pack("padx" => 50, "pady" => 50, "side" => "left")
		grid('row' => 2, 'column' => 1)
	}

	TkButton.new ($session) {
		text "Transferencia - Conta Corrente"
		pack("padx" => 50, "pady" => 50, "side" => "left")
		grid('row' => 3, 'column' => 0)
	}

	TkButton.new ($session) {
		text "Transferencia - Conta Poupansa"
		pack("padx" => 50, "pady" => 50, "side" => "left")
		grid('row' => 3, 'column' => 1)
	}

	TkLabel.new ($session){
		text "Conta: #{nome}"
		pack("padx" => 50, "pady" => 50, "side" => "left")
		grid('row' => 0, 'column' => 0)
	}

	TkLabel.new ($session){
		text "Conta: #{cc}: R$#{scc}"
		pack("padx" => 50, "pady" => 50, "side" => "left")
		grid('row' => 0, 'column' => 1)
	}

	TkLabel.new ($session){
		text "Conta: #{cp}: R$#{scp}"
		pack("padx" => 50, "pady" => 50, "side" => "left")
		grid('row' => 0, 'column' => 2)
	}

	TkButton.new ($session){
		text "Sair"
		command "$root.raise;$session.destroy;"
		pack("padx" => 5, "pady" => 5, "side" => "left")
		grid('row' => 5, 'column' => 1)
	}

end

Tk.mainloop
