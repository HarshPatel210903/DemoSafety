using DATA_ACCESS_LAYER.Models;

using DemoSafety.Models;
using DemoSafety.Pages;

using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

using System.Data;
using System.Data.SqlClient;
using BALForDemoSafety.Services;
using DALForDemoSafety.Models;
namespace DemoSafety.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class LoginController : ControllerBase
    {
        private readonly string connectionString;
        private readonly LoginService _Services;
        public LoginController(IConfiguration configuration,LoginService loginservice)
        {
            connectionString = configuration.GetConnectionString("DefaultConnection");
            _Services = loginservice;
        }
        [HttpPost]
        public async Task<CommonDataOut> Login([FromBody] LoginFormModel model)
        {
            try
            {
               return _Services.Login(model);
            }
            catch (Exception ex)
            {
                return new CommonDataOut { StatusCode = 500, StatusMessage = $"Internal server error: {ex.Message}",Data=null };
            }
        }
    }
}
