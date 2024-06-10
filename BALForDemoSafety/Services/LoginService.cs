using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using BALForDemoSafety.Extensions;

using DALForDemoSafety.Contacts;
using DATA_ACCESS_LAYER.Models;

using Microsoft.AspNetCore.Mvc;
using DALForDemoSafety.Models;
namespace BALForDemoSafety.Services
{
    public class LoginService: Login
    {
        private readonly IRepository _Repository;
        public LoginService(IRepository Repository)
        {
            _Repository = Repository;
        }
        public CommonDataOut Login([FromBody] LoginFormModel model)
        {
            return _Repository.Login(model);
        }
    }
}
