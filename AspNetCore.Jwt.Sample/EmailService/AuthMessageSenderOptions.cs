using System;

namespace AspNetCore.Jwt.Sample.EmailService
{
    public class AuthMessageSenderOptions
    {
        public string SendGridUser { get; set; }
        public string SendGridKey { get; set; }
    }
}