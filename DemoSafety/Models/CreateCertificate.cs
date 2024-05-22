using System.ComponentModel.DataAnnotations;

namespace DemoSafety.Models
{
    public class CreateCerti
    {
        [Required]
        public string StudentName { get; set; }
        [Required]
        public string Description { get; set; }
        [Required]
        public int createdBy { get; set; }
    }
}
