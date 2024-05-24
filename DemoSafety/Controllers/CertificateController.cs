using DemoSafety.Models;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

using System.Data.SqlClient;

using System.Data;

namespace DemoSafety.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class CertificateController : ControllerBase
    {
        private readonly string connectionString;
        public CertificateController(IConfiguration configuration)
        {
            connectionString = configuration.GetConnectionString("DefaultConnection");
        }


        [HttpPost]
        [Route("ApproveCertificate")]
        public async Task<IActionResult> ApproveCertificate(int certificateId, int userId, string? comment)
        {
            try
            {
                string userQuery = "[dbo].[pApproveCertificate]";
                SqlParameter[] parameters = { new SqlParameter("@CertificateID", certificateId),
                new SqlParameter("@ApproverID",userId),
                new SqlParameter("@Comments",comment)};

                DataTable result = await adoMethod.ExecuteStoredProcedureAsync(connectionString, userQuery, parameters);
                return Ok(new { message = "Approved Successfully" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Internal server error: {ex.Message}" });
            }
        }
        [HttpPost]
        [Route("RejectCertificate")]
        public async Task<IActionResult> RejectCertificate(int certificateId, int userId, string? comment)
        {
            try
            {
                string userQuery = "[dbo].[pRejectCertificate]";
                SqlParameter[] parameters = { new SqlParameter("@CertificateID", certificateId),
                new SqlParameter("@ApproverID",userId),
                new SqlParameter("@Comments",comment)};

                DataTable result = await adoMethod.ExecuteStoredProcedureAsync(connectionString, userQuery, parameters);
                return Ok(new { message = "Rejected Successfully" });
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Internal server error: {ex.Message}" });
            }
        }
    }
}
