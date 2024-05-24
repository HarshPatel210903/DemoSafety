using DemoSafety.Models;
using DemoSafety.Pages;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

using System.Data;
using System.Data.SqlClient;

namespace DemoSafety.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private readonly string connectionString;
        public LoginController(IConfiguration configuration)
        {
            connectionString = configuration.GetConnectionString("DefaultConnection");
        }
        [HttpPost]
        public async Task<IActionResult> Login([FromBody] LoginFormModel model)
        {
            try
            {
                string userQuery = "SELECT UserID,Name,password,RoleName FROM tUsers "+
                    "join tRoles on tRoles.RoleID = tUsers.Role "+
                    "WHERE email = @email AND tRoles.RoleType = @org;";
                SqlParameter[] parameters = { new SqlParameter("@email", model.email),
                new SqlParameter("@org",model.org)};

                DataTable result = await adoMethod.ExecuteAsyncTodata(connectionString, userQuery, parameters);

                if (result.Rows.Count > 0)
                {
                    string userId = result.Rows[0]["UserID"].ToString();
                    string name = result.Rows[0]["Name"].ToString();
                    string storedPassword = result.Rows[0]["password"].ToString();
                    string role = result.Rows[0]["RoleName"].ToString();
                    if (storedPassword == model.password)
                    {
                        return Ok(new { message = "Authentication successful", role = role, userId = userId, name = name });
                    }
                    else
                    {
                        return Unauthorized(new { message = "Password is incorrect" });
                    }
                }
                else
                {
                    return NotFound(new { message = "User does not exist" });
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Internal server error: {ex.Message}" });
            }
        }
    }
}
