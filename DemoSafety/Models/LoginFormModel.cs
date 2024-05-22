using System.ComponentModel.DataAnnotations;

namespace DemoSafety.Models
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