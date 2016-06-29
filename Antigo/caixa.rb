require 'tk'

class Login
	def initialize
		@root = TkRoot.new {title "Caixa Eletronico"}

		@contaLabel = TkLabel.new (@root) {
			text "Conta:"
			pack("padx" => 5, "pady" => 5, "side" => "left")
			grid('row' => 0, 'column' => 0)
		}


		@contaEntry = TkEntry.new (@root) {
			pack('padx'=>10, 'pady'=>10, 'side'=>'left')
			grid('row' => 0, 'column' => 1)
		}

		@senhaLabel = TkLabel.new (@root) {
			text "Senha:"
			pack("padx" => 5, "pady" => 5, "side" => "left")
			grid('row' => 1, 'column' => 0)
		}

		@senhaEntry = TkEntry.new (@root) {
			show '*'
			pack("padx" => 10, "pady" => 10, "side" => "left")
			grid('row' => 1, 'column' => 1)
		}

		@entrarButton = TkButton.new (@root) {
			text "Entrar"
			pack("padx" => 10, "pady" => 10, "side" => "left")
			grid('row' => 2, 'column' => 1)
			command "$login.login"
		}

		@conta = TkVariable.new
		@senha = TkVariable.new

		@contaEntry.textvariable = @conta
		@senhaEntry.textvariable = @senha

	end

	def login
		# Methodo de Login
		puts "Starting login"
		puts "with: #{@conta.value}"

		
	end

end


$login = Login.new
Tk.mainloop
