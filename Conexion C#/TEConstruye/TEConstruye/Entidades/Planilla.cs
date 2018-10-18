using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data;
using System.Data.SqlClient;
using System.Data.Sql;

namespace TEConstruye.Entidades
{
    class Planilla
    {
        string configuracion = "Data Source=USUARIO-PC\\SQLEXPRESS;Initial Catalog=TEConstruye;Integrated Security=True";


        public void Select(DataGridView dvg,int semana)
        {
            SqlConnection conexion = new SqlConnection(configuracion); //conexión
            

            conexion.Open();
            SqlCommand comando = new SqlCommand("Planilla",conexion);
            comando.CommandType = CommandType.StoredProcedure;
            comando.Parameters.AddWithValue("semana", semana);
            


            DataTable tabla = new DataTable();
            tabla.Load(comando.ExecuteReader());
            dvg.DataSource = tabla;

            conexion.Close();
        }
    }
}
