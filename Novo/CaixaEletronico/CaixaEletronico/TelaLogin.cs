using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

using Fleyhe.Network;

namespace CaixaEletronico
{
    public partial class TelaLogin : Form
    {

        public static TelaLogin tela;

        public TelaLogin()
        {
            InitializeComponent();
            tela = this;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string conta = textBox_Conta.Text;
            string senha = textBox_Senha.Text;

            TelaSelecao tela = new TelaSelecao();

            Authentication.name = conta;
            Authentication.password = senha;

            string[] args = new string[2];
            args[0] = Authentication.name;
            args[1] = Authentication.password;
            Request req = new Request("LogarFunc", args);
            if (req.Event.Normalize() == "ok")
            {
                tela.Show();
                this.Hide();
            } else
            {
                MessageBox.Show
                ("Impossível logar");
            }


            

        }

        
    }
}
