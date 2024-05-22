using DemoSafety.Models;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

using System.Data.SqlClient;

using System.Data;

namespace DemoSafety.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CreateCertiController : ControllerBase
    {
        private readonly string connectionString;
        public CreateCertiController(IConfiguration configuration)
        {
            connectionString = configuration.GetConnectionString("DefaultConnection");
        }


        [HttpPost]
        public async Task<IActionResult> Create(CreateCerti model)
        {
            try
            {
                string userQuery = "[dbo].[pCreateCertificate]";
                SqlParameter[] parameters = { new SqlParameter("@StudentName", model.StudentName),
                new SqlParameter("@Description",model.Description),
                new SqlParameter("@CreatedBy",model.createdBy)};

                DataTable result = await adoMethod.ExecuteStoredProcedureAsync(connectionString, userQuery, parameters);
                return Ok();
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Internal server error: {ex.Message}" });
            }
        }
    }
}
