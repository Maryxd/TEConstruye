using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using TEConstruye.Entidades;

namespace TEConstruye
{
    public partial class TEConstruye : Form
    {
        public TEConstruye()
        {
            InitializeComponent();
            

        }

        private void consultar(string x)
        {
            if (x == "Empleados"){
                Empleados empleados = new Empleados();
                empleados.Select(dataGridView1);
            }
            if (x == "Ingenieros")
            {
                Ingenieros ingenieros = new Ingenieros();
                ingenieros.Select(dataGridView1);
            }

            if (x == "Materiales")
            {
                Materiales materiales = new Materiales();
                materiales.Select(dataGridView1);
            }
        }

        private void button1_Click(object sender, EventArgs e)
        {
            consultar("Empleados");
        }

        private void button2_Click(object sender, EventArgs e)
        {
            consultar("Ingenieros");
        }

        private void button3_Click(object sender, EventArgs e)
        {
            consultar("Materiales");
        }

        private void button4_Click(object sender, EventArgs e)
        {
            string texto = Texto1.Text;
            int sem = Int32.Parse(texto);
            Planilla planilla = new Planilla();
            planilla.Select(dataGridView1, sem);
        }
    }
}
