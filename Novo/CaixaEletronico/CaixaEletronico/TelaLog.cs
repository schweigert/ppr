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
    public partial class TelaLog : Form
    {
        public TelaLog()
        {
            InitializeComponent();
            string[] args = new string[2];
            args[0] = Authentication.name;
            args[1] = Authentication.password;

            Request req = new Request("Log", args);

            string log = "";

            for(int i = 0; i < req.response.Length; i++)
            {
                Console.WriteLine(req.response[i]);
                log += req.response[i] + "\r\n";
            }

            richTextBox1.Text = log;
        }

    }
}
