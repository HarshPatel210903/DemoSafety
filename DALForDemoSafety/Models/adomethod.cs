using System.Data.SqlClient;
using System.Data;

namespace DALForDemoSafety.Models
{
    public class adoMethod
    {
        public static async Task<DataTable> ExecuteAsyncTodataNoParameter(string constring, string query)
        {
            DataTable tab = new DataTable();
            try
            {
                using (SqlConnection sqlConnection = new SqlConnection(constring))
                {
                    SqlCommand command = new SqlCommand(query, sqlConnection);
                    await sqlConnection.OpenAsync();
                    SqlDataReader reader = await command.ExecuteReaderAsync();
                    tab.Load(reader);
                    return tab;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                return null;
            }
        }
        public static DataTable ExecuteTodata(string constring, string query, params SqlParameter[] paramterList)
        {
            DataTable tab = new DataTable();
            try
            {
                using (SqlConnection sqlConnection = new SqlConnection(constring))
                {
                    SqlCommand command = new SqlCommand(query, sqlConnection);
                    command.Parameters.AddRange(paramterList);
                    sqlConnection.Open();
                    SqlDataReader reader = command.ExecuteReader();
                    tab.Load(reader);
                    return tab;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                return null;
            }
        }
        public static async Task<object> ExecuteScalarAsyncTodata(string constring, string query, params SqlParameter[] paramterList)
        {
            DataTable tab = new DataTable();
            try
            {
                using (SqlConnection sqlConnection = new SqlConnection(constring))
                {
                    SqlCommand command = new SqlCommand(query, sqlConnection);
                    command.Parameters.AddRange(paramterList);
                    await sqlConnection.OpenAsync();
                    object x = await command.ExecuteScalarAsync();
                    return x;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                return null;
            }
        }
        public static async Task<int> ExecuteAsyncNonQuery(string constring, string query, params SqlParameter[] parameterList)
        {
            int rowsAffected = 0;
            using (SqlConnection sqlConnection = new SqlConnection(constring))
            {
                try
                {
                    SqlCommand command = new SqlCommand(query, sqlConnection);
                    command.Parameters.AddRange(parameterList);
                    await sqlConnection.OpenAsync();
                    rowsAffected = await command.ExecuteNonQueryAsync();
                    return rowsAffected;
                }
                catch (Exception ex)
                {
                    Console.WriteLine(ex);
                    return 0;
                }
            }
        }
        public static async Task<DataTable> ExecuteStoredProcedureAsync(string constring, string storedProcedureName, params SqlParameter[] parameterList)
        {
            DataTable tab = new DataTable();
            try
            {
                using (SqlConnection sqlConnection = new SqlConnection(constring))
                {
                    SqlCommand command = new SqlCommand(storedProcedureName, sqlConnection);
                    command.CommandType = CommandType.StoredProcedure;
                    command.Parameters.AddRange(parameterList);
                    await sqlConnection.OpenAsync();
                    SqlDataReader reader = await command.ExecuteReaderAsync();
                    tab.Load(reader);
                    return tab;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                return null;
            }
        }
        public static async Task<DataTable> ExecuteStoredProcedureAsync(string constring, string storedProcedureName)
        {
            DataTable tab = new DataTable();
            try
            {
                using (SqlConnection sqlConnection = new SqlConnection(constring))
                {
                    SqlCommand command = new SqlCommand(storedProcedureName, sqlConnection);
                    command.CommandType = CommandType.StoredProcedure;
                    await sqlConnection.OpenAsync();
                    SqlDataReader reader = await command.ExecuteReaderAsync();
                    tab.Load(reader);
                    return tab;
                }
            }
            catch (Exception ex)
            {
                Console.WriteLine(ex);
                return null;
            }
        }



        public static object GetNullableForDatabase(string input)
        {
            return string.IsNullOrEmpty(input) ? DBNull.Value : (object)input;
        }
    }
}
