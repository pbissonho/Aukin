using AspNetCore.Jwt.Sample.Config;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using NetDevPack.Identity;
using NetDevPack.Identity.User;

namespace AspNetCore.Jwt.Sample
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers();

            // When you have specifics configurations (see inside this method)
            services.AddCustomIdentityConfiguration(Configuration);

            services.AddAspNetUserConfiguration();

            services.AddSwaggerConfiguration();

            services.AddDependencyInjectionConfiguration();
        }

        public async void Configure(
            IApplicationBuilder app,
            IWebHostEnvironment env,
            MyIdentityContext context,
            UserManager<MyIdentityUser> userManager,
            RoleManager<IdentityRole> roleManager)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            // Start the database with some users and clams.    
            var initializer = new IdentityInitializer(context, userManager, roleManager);
            await initializer.Initialize();

            app.UseSwaggerConfiguration();

            app.UseHttpsRedirection();

            app.UseRouting();

            // Custom NetDevPack abstraction here!
            app.UseAuthConfiguration();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}
