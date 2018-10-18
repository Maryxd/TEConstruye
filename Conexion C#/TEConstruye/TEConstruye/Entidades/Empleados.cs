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
    class Empleados
    {
        string configuracion = "Data Source=USUARIO-PC\\SQLEXPRESS;Initial Catalog=TEConstruye;Integrated Security=True";


        public void Select(DataGridView dvg)
        {
            SqlConnection conexion = new SqlConnection(configuracion); //conexión
            String consulta = "SELECT * FROM Empleados";//la consulta

            conexion.Open();
            SqlDataAdapter adapter = new SqlDataAdapter(consulta, conexion);

            DataSet dataSet = new DataSet();
            adapter.Fill(dataSet, "Empleado");
            dvg.DataSource = dataSet.Tables["Empleado"];

            conexion.Close();
        }
    }
}
