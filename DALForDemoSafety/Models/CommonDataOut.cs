using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DATA_ACCESS_LAYER.Models
{
    public class CommonDataOut
    {
        public int StatusCode { get; set; }
        public string StatusMessage { get; set; }
        public string Data { get; set; }

    }
}
