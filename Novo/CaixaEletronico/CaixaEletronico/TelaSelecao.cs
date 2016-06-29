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
    public partial class TelaSelecao : Form
    {
        public TelaSelecao()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            TelaDeposito td = new TelaDeposito();
            td.Show();
        }

        private void button12_Click(object sender, EventArgs e)
        {
            this.Dispose();
            TelaLogin.tela.Show();
        }

        private void button13_Click(object sender, EventArgs e)
        {
            TelaLog log = new TelaLog();
            log.Show();
        }

        private void button9_Click(object sender, EventArgs e)
        {
            TelaCadastroCliente tcc = new TelaCadastroCliente();
            tcc.Show();
        }

        private void button8_Click(object sender, EventArgs e)
        {
            string[] args = new string[1];
            args[0] = "qq coisa";
            Request req = new Request("ConfirmJuros", args);
            if (req.Event.ToString().Normalize() == "ok")
            {
                MessageBox.Show("Atualizado");
            } else
            {
                MessageBox.Show("Erro");
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            TelaTranferencia td = new TelaTranferencia();
            td.Show();
        }

        private void button4_Click(object sender, EventArgs e)
        {
            TelaSaque ts = new TelaSaque();
            ts.Show();
        }

        private void button5_Click(object sender, EventArgs e)
        {
            TelaPagamento tp = new TelaPagamento();
            tp.Show();
        }

        private void button3_Click(object sender, EventArgs e)
        {
            TelaExtrato te = new TelaExtrato();
            te.Show();
        }

        private void button7_Click(object sender, EventArgs e)
        {
            TelaBoleto tb = new TelaBoleto();
            tb.Show();
        }

        private void button10_Click(object sender, EventArgs e)
        {
            TelaAlterarConta tac = new TelaAlterarConta();
            tac.Show();
        }

        private void button11_Click(object sender, EventArgs e)
        {
            TelaAlterarFuncionario taf = new TelaAlterarFuncionario();
            taf.Show();
        }

        private void button6_Click(object sender, EventArgs e)
        {
            TelaPoupanca tp = new TelaPoupanca();
            tp.Show();
        }
    }
}
