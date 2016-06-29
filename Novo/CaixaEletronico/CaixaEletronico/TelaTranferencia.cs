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
    public partial class TelaTranferencia : Form
    {
        public TelaTranferencia()
        {
            InitializeComponent();
        }

        private void button1_Click(object sender, EventArgs e)
        {
            string de = textBox1.Text;
            string para = textBox2.Text;
            bool dep = checkBox2.Checked;
            bool parap = checkBox1.Checked;
            float valor = 0.0f;

            if (float.TryParse(textBox3.Text, out valor))
            {
                string[] args = new string[5];
                args[0] = de;
                args[1] = para;

                if (dep) args[2] = "t";
                else args[2] = "f";

                if (parap) args[3] = "t";
                else args[3] = "f";

                args[4] = valor.ToString();

                Request req = new Request("Deposito", args);

                if (req.Event.Normalize() == "ok")
                {
                    MessageBox.Show("Transação realizada com Sucesso");
                } else
                {
                    MessageBox.Show("Erro na transação. Tente novamente");
                }

            } else
            {
                MessageBox.Show("Valor não é um número válido");
            }


        }
    }
}
