require 'tk'
require 'SuricatoNetwork'

$ip = "localhost"
$port = 3030

class Login < SuricatoNetwork::Event
	def Solve
		Tk::messageBox :message => 'Login bem sucedido'
	end
end

class InvalidLogin < SuricatoNetwork::Event
	def Solve
		Tk::messageBox :message => 'Usuario e/ou senha incorretos'
	end
end


def startGui
    $root = TkRoot.new {
	    title "Caixa Eletronico"
    }

	contaLabel = TkLabel.new ($root) {
		text "Conta:"
		pack("padx" => 5, "pady" => 5, "side" => "left")
		grid('row' => 0, 'column' => 0)
	}


	contaEntry = TkEntry.new ($root) {
		pack('padx'=>10, 'pady'=>10, 'side'=>'left')
		grid('row' => 0, 'column' => 1)
	}

	senhaLabel = TkLabel.new ($root) {
		text "Senha:"
		pack("padx" => 5, "pady" => 5, "side" => "left")
		grid('row' => 1, 'column' => 0)
	}

	senhaEntry = TkEntry.new ($root) {
		show '*'
		pack("padx" => 10, "pady" => 10, "side" => "left")
		grid('row' => 1, 'column' => 1)
	}


	TkButton.new ($root) {
		text "Entrar"
		pack("padx" => 50, "pady" => 50, "side" => "left")
		grid('row' => 2, 'column' => 1)
		command 'login_btn'
	}


	# Variaveis

	$senhaLabelVariable = TkVariable.new
	$contaLabelVariable = TkVariable.new
    
	contaEntry.textvariable = $contaLabelVariable
	senhaEntry.textvariable = $senhaLabelVariable

end

def login_btn
	begin
		conn = SuricatoNetwork::Connection.new $ip, $port
		conn.call "Login",[$contaLabelVariable.value,$senhaLabelVariable.value]
	rescue => e
		Tk::messageBox :message => e.to_s
	end
end

startGui
Tk.mainloop
