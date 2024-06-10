﻿using DALForDemoSafety.Models;
using DATA_ACCESS_LAYER.Models;
using Microsoft.AspNetCore.Mvc;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DALForDemoSafety.Contacts
{
    public interface IRepository
    {
        public CommonDataOut Login([FromBody] LoginFormModel model);
    }
}
