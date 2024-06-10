using DALForDemoSafety.Contacts;
using DALForDemoSafety.Models;

using Microsoft.Extensions.Configuration;

using System.Data;
using System.Data.SqlClient;
using Microsoft.AspNetCore.Mvc;
using DATA_ACCESS_LAYER.Models;
using Newtonsoft.Json;

namespace DALForDemoSafety.Repositories
{
    internal class LoginForm : IRepository
    {
        private readonly string connectionString;
        public LoginForm(IConfiguration configuration)
        {
            connectionString = configuration.GetConnectionString("DefaultConnection");
        }
        public CommonDataOut Login([FromBody] LoginFormModel model)
        {
            try
            {
                string userQuery = "SELECT UserID,Name,password,RoleName FROM tUsers " +
                    "join tRoles on tRoles.RoleID = tUsers.Role " +
                    "WHERE email = @email AND tRoles.RoleType = @org;";
                SqlParameter[] parameters = { new SqlParameter("@email", model.email),
                new SqlParameter("@org",model.org)};

                DataTable result = adoMethod.ExecuteTodata(connectionString, userQuery, parameters);

                if (result.Rows.Count > 0)
                {
                    string userId = result.Rows[0]["UserID"].ToString();
                    string name = result.Rows[0]["Name"].ToString();
                    string storedPassword = result.Rows[0]["password"].ToString();
                    string role = result.Rows[0]["RoleName"].ToString();
                    if (storedPassword == model.password)
                    {
                        var data = new { role = role, userId = userId, name = name};
                        return new CommonDataOut() { StatusCode = 200, StatusMessage = "Authentication successful", Data = JsonConvert.SerializeObject(data) };
                    }
                    else
                    {
                        return new CommonDataOut() { StatusCode = 401, StatusMessage = "Password is incorrect", Data=null};
                    }
                }
                else
                {
                    return new CommonDataOut() { StatusCode = 404, StatusMessage = "User does not exist", Data = null };
                }
            }
            catch (Exception ex)
            {
                return new CommonDataOut() { StatusCode = 500, StatusMessage = $"Internal server error: {ex.Message}", Data = null };
            }
        }
    }
}
