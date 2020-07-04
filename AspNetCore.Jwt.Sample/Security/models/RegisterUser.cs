using System.ComponentModel.DataAnnotations;

namespace AspNetCore.Jwt.Sample.Model
{
    public class CustomRegisterUser
    {
        [EmailAddress]
        [Required]
        public string Email { get; set; }

        [Required]
        [StringLength(70, MinimumLength = 5)]
        public string Name { get; set; }
        [Required]
        [StringLength(100, MinimumLength = 6)]
        public string Password { get; set; }
        [Compare("Password")]
        public string ConfirmPassword { get; set; }
    }

    public class CustomLoginUser
    {

        [Required]
        public string Name { get; set; }
        [Required]
        [StringLength(100, MinimumLength = 6)]
        public string Password { get; set; }
    }
}