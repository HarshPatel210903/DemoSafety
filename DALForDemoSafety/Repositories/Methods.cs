using DALForDemoSafety.Contacts;
using Microsoft.Extensions.Configuration;

using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DALForDemoSafety.Repositories
{
    internal class Methods : IRepository
    {
        private readonly string _configuration;
        public Methods(IConfiguration configuration)
        {
            _configuration = configuration.GetConnectionString("DefaultConnection");

        }
    }
}
