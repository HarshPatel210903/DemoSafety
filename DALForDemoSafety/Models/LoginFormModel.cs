using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace DALForDemoSafety.Models
{
    public class LoginFormModel
    {
        [Required]
        public string email { get; set; }
        [Required]
        public string password { get; set; }
        [Required]
        public int org { get; set; }
    }
}
