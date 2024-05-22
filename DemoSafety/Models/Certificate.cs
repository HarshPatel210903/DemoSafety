namespace DemoSafety.Models
{
    public class Certificate
    {
        public long CertificateID { get; set; }
        public string StudentName { get; set; }
        public string Description { get; set; }
        public DateTime DateIssued { get; set; }
        public string Status { get; set; }
        public DateTime LastUpdated { get; set; }
    }
}
