using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Identity;
using AspNetCore.Jwt.Sample.EmailService;
using Microsoft.Extensions.Configuration;

namespace AspNetCore.Jwt.Sample.Config
{
    public static class DependencyInjectionConfig
    {
        public static IServiceCollection AddDependencyInjectionConfiguration(this IServiceCollection services, Microsoft.Extensions.Configuration.IConfiguration configuration)
        {
            services.AddScoped<SignInManager<MyIdentityUser>>();
            services.AddScoped<UserManager<MyIdentityUser>>();
            services.AddScoped<RoleManager<IdentityRole>>();
            services.AddTransient<IEmailSender, SendGridEmailSender>();

            services.Configure<AuthMessageSenderOptions>(configuration.GetSection("SendGrid"));
            return services;
        }
    }
}