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
    public partial class TelaSaque : Form
    {
        public TelaSaque()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            float valor = 0;
            if (!float.TryParse(textBox2.Text,out valor))
            {
                MessageBox.Show("Erro: Valor inválido");
                return;
            }

            string conta = textBox1.Text;
            string cpoup = "f";
            if (checkBox1.Checked) cpoup = "t";
            string senha = textBox3.Text;

            string[] args = new string[4];
            args[0] = conta.ToString();
            args[1] = valor.ToString();
            args[2] = cpoup.ToString();
            args[3] = senha.ToString();

            Request req = new Request("Saque", args);

            Console.WriteLine(req.Event);

            if (req.Event.Normalize() == "ok")
            {
                MessageBox.Show("Saque efetuado com sucesso.");
                this.Dispose();
            } else
            {
                MessageBox.Show("Erro na operação. Confirme seus dados");
            }
            
        }
    }
}
