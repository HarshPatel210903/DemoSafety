using DemoSafety.Models;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

using System.Data.SqlClient;

using System.Data;

namespace DemoSafety.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class GetCertificateController : ControllerBase
    {
        private readonly string connectionString;
        public GetCertificateController(IConfiguration configuration)
        {
            connectionString = configuration.GetConnectionString("DefaultConnection");
        }


        [HttpGet]
        [Route("GetforPrincipal")]
        public async Task<IActionResult> GetforPrincipal()
        {
            try
            {
                string userQuery = "[dbo].[pGetCertificatesForPrincipal]";

                DataTable result = await adoMethod.ExecuteStoredProcedureAsync(connectionString, userQuery);
                if (result.Rows.Count > 0)
                {
                    List<Certificate> certiList = new List<Certificate>();
                    foreach (DataRow row in result.Rows)
                    {
                        Certificate certi = new Certificate();
                        certi.CertificateID = Convert.ToInt64(row["CertificateID"]);
                        certi.StudentName = row["StudentName"].ToString();
                        certi.Description = row["Description"].ToString();
                        certi.DateIssued = Convert.ToDateTime(row["DateIssued"]);
                        certi.Status = row["Status"].ToString();
                        certi.LastUpdated = Convert.ToDateTime(row["LastUpdated"]);
                        certiList.Add(certi);
                    }
                    return Ok(new { data = certiList, message = "certificates retrived successfully" });
                }
                else
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Internal server error: {ex.Message}" });
            }
        }
        [HttpGet]
        [Route("GetforReviewer")]
        public async Task<IActionResult> GetforReviewer(int userId)
        {
            try
            {
                string userQuery = "[dbo].[pGetCertificatesForReviewer]";

                DataTable result = await adoMethod.ExecuteStoredProcedureAsync(connectionString, userQuery, new SqlParameter("@reviewerID",userId));
                if (result.Rows.Count > 0)
                {
                    List<Certificate> certiList = new List<Certificate>();
                    foreach (DataRow row in result.Rows)
                    {
                        Certificate certi = new Certificate();
                        certi.CertificateID = Convert.ToInt64(row["CertificateID"]);
                        certi.StudentName = row["StudentName"].ToString();
                        certi.Description = row["Description"].ToString();
                        certi.DateIssued = Convert.ToDateTime(row["DateIssued"]);
                        certiList.Add(certi);
                    }
                    return Ok(new { data = certiList, message = "certificates retrived successfully" });
                }
                else
                {
                    return Ok(new {message="no certificates to review"});
                }
            }
            catch (Exception ex)
            {
                return StatusCode(500, new { message = $"Internal server error: {ex.Message}" });
            }
        }
    }
}
