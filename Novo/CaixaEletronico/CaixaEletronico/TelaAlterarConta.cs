using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Windows.Forms;

namespace CaixaEletronico
{
    public partial class TelaAlterarConta : Form
    {
        public TelaAlterarConta()
        {
            InitializeComponent();
        }

        private void TelaAlterarConta_Load(object sender, EventArgs e)
        {}

        private void button2_Click(object sender, EventArgs e)
        {
            TelaExibirClientes tec = new TelaExibirClientes();
            tec.Show();
        }
    }
}
