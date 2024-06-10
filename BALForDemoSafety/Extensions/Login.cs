using DALForDemoSafety.Models;
using DATA_ACCESS_LAYER.Models;
using Microsoft.AspNetCore.Mvc;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace BALForDemoSafety.Extensions
{
    public interface Login
    {
        public CommonDataOut Login([FromBody] LoginFormModel model);
    }
}
