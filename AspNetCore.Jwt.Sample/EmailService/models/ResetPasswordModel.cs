using System.ComponentModel.DataAnnotations;

namespace AspNetCore.Jwt.Sample.EmailService.models
{
    public class ResetPasswordModel
    {
        [Required]
        [DataType(DataType.Password)]
        public string Password { get; set; }

        [DataType(DataType.Password)]
        [Compare("Password", ErrorMessage = "The password and confirmation password do not match.")]
        public string ConfirmPassword { get; set; }
        public string Email { get; set; }
        public string Code { get; set; }
    }
}

