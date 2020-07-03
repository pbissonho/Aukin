using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
namespace AspNetCore.Jwt.Sample.Config
{
    public static class DependencyInjectionConfig
    {
        public static IServiceCollection AddDependencyInjectionConfiguration(this IServiceCollection services)
        {
            services.AddScoped<SignInManager<MyIdentityUser>>();
            services.AddScoped<UserManager<MyIdentityUser>>();    
            services.AddScoped<RoleManager<IdentityRole>>();
            return services;
        }
    }
}