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
    public partial class TelaCadastroCliente : Form
    {
        public TelaCadastroCliente()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            // Pegar Dados
            string nome = textBox1.Text;
            string cc = textBox2.Text;
            string cp = textBox3.Text;

            string senha1 = textBox4.Text;
            string senha2 = textBox5.Text;

            // Verificar se a senha 1 = senha 2
            if (senha1 != senha2)
            {
                MessageBox.Show("As duas senhas não são iguais");
                return;
            }
            string[] args = new string[4];
            args[0] = nome;
            args[1] = cc;
            args[2] = cp;
            args[3] = senha1;
            Request req = new Request("CriarCliente",args);

            if (req.Event.Normalize() == "ok")
            {
                MessageBox.Show("Usuário criado com sucesso");
                this.Dispose();
            } else
            {
                MessageBox.Show("Erro na criação do usuário");
            }
        }
    }
}
