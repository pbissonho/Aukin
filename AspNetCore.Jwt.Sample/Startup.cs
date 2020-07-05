using System.Linq;
using System.Text.Json;
using AspNetCore.Jwt.Sample.Config;
using AspNetCore.Jwt.Sample.Controllers.Error;
using AspNetCore.Jwt.Sample.EmailService;
using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using NetDevPack.Identity;
using NetDevPack.Identity.User;
using Newtonsoft.Json;

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

             services.AddDistributedRedisCache(options =>
            {
                options.Configuration =
                    Configuration.GetConnectionString("ConexaoRedis");
                options.InstanceName = "APICotacoes-";
            });

            services.AddMemoryCache();

            services.Configure<ApiBehaviorOptions>(options =>
           {
               options.InvalidModelStateResponseFactory = context =>
               {
                   var errors = context.ModelState.Values.SelectMany(e => e.Errors);
                   var apiError = new BadRequestError();

                   foreach (var error in errors)
                   {
                       apiError.AddMessage(error.ErrorMessage);
                   }

                   string json = JsonConvert.SerializeObject(apiError, Formatting.Indented);
                   var result = new BadRequestObjectResult(json);
                   result.ContentTypes.Clear();
                   return result;
               };
           });


            services.AddAspNetUserConfiguration();

            services.AddSwaggerConfiguration();

            services.AddDependencyInjectionConfiguration(Configuration);
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
