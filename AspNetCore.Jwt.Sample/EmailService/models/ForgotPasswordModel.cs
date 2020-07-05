using System.ComponentModel.DataAnnotations;

namespace AspNetCore.Jwt.Sample.EmailService.models
{
    public class ForgotPasswordModel
    {
        [Required]
        [EmailAddress]
        public string Email { get; set; }
    }
}