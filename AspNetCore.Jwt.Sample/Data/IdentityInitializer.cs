using System;
using Microsoft.AspNetCore.Identity;
using System.Collections.Generic;
using System.Threading.Tasks;
using System.Security.Claims;

namespace AspNetCore.Jwt.Sample.Config
{
    public class IdentityInitializer
    {
        private readonly MyIdentityContext _context;
        private UserManager<MyIdentityUser> _userManager;
        private readonly RoleManager<IdentityRole> _roleManager;

        public IdentityInitializer(
            MyIdentityContext context,
            UserManager<MyIdentityUser> userManager,
            RoleManager<IdentityRole> roleManager)
        {
            _context = context;
            _userManager = userManager;
            _roleManager = roleManager;
        }

        public async Task Initialize()
        {
            if (_context.Database.EnsureCreated())
            {
                var adminRole = await _roleManager.CreateAsync(
                         new IdentityRole(Roles.ADMIN));
                await _roleManager.CreateAsync(
                         new IdentityRole(Roles.BASIC));

                var basicRole = await _roleManager.FindByNameAsync(Roles.BASIC);
                await _roleManager.AddClaimAsync(basicRole, new Claim(Claims.Sample, ClaimsValues.READ));

                var user = new MyIdentityUser
                {
                    UserName = "pbissonho",
                    Email = "pedro.bissonho@gmail.com",
                    EmailConfirmed = true,
                };


                await _userManager.CreateAsync(user, "pedro123PEDRO@");
                await _userManager.AddToRoleAsync(user, Roles.BASIC);
                await _userManager.AddClaimAsync(user, new Claim(Claims.Sample, ClaimsValues.READ));

            }
        }
    }
}
