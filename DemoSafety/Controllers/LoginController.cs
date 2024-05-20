﻿using DemoSafety.Models;
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
                string userQuery = "SELECT Password,RoleName FROM tUsers join tRoles on tRoles.RoleID = tUsers.Role WHERE email = @email";
                SqlParameter[] parameters = { new SqlParameter("@email", model.email) };

                DataTable result = await adoMethod.ExecuteAsyncTodata(connectionString, userQuery, parameters);

                if (result.Rows.Count > 0)
                {
                    string storedPassword = result.Rows[0]["password"].ToString();
                    string role = result.Rows[0]["RoleName"].ToString();
                    if (storedPassword == model.password)
                    {
                        return Ok(new { message = "Authentication successful", role = role });
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
