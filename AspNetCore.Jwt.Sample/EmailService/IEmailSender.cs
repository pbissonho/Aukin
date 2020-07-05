using System.Threading.Tasks;

namespace AspNetCore.Jwt.Sample.EmailService
{
    public interface IEmailSender
    {
        Task SendEmailAsync(string email, string subject, string message);
    }
}