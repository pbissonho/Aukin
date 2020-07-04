using System.Threading.Tasks;
using AspNetCore.Jwt.Sample.Config;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Options;
using NetDevPack.Identity.Jwt;
using NetDevPack.Identity.Jwt.Model;
using NetDevPack.Identity.Model;
using AspNetCore.Jwt.Sample.Security;
using AspNetCore.Jwt.Sample.Security.models;
using System.Collections.Generic;
using AspNetCore.Jwt.Sample.Model;
using System.Security.Claims;

namespace AspNetCore.Jwt.Sample.Controllers
{
    [Route("api/account")]
    public class AuthController : CustomController
    {
        private readonly SignInManager<MyIdentityUser> _signInManager;
        private readonly UserManager<MyIdentityUser> _userManager;
        private readonly AppJwtSettings _appJwtSettings;

        public AuthController(SignInManager<MyIdentityUser> signInManager,
            UserManager<MyIdentityUser> userManager,
            IOptions<AppJwtSettings> appJwtSettings)
        {
            _signInManager = signInManager;
            _userManager = userManager;
            _appJwtSettings = appJwtSettings.Value;
        }

        [HttpPost("register")]
        public async Task<ActionResult> Register(CustomRegisterUser registerUser)
        {
            if (!ModelState.IsValid) return CustomResponse(ModelState);

            var user = new MyIdentityUser
            {
                UserName = registerUser.Name,
                Email = registerUser.Email,
                EmailConfirmed = true
            };

            var result = await _userManager.CreateAsync(user, registerUser.Password);


            if (result.Succeeded)
            {
                await _userManager.AddToRoleAsync(user, Roles.ROLE_BASIC);
                return CustomResponse(createToken(user.UserName));
            }

            foreach (var error in result.Errors)
            {
                AddError(error.Description);
            }

            return CustomResponse();
        }

        [HttpPost("login")]
        public async Task<ActionResult> Login(CustomLoginUser loginUser)
        {
            if (!ModelState.IsValid) return CustomResponse(ModelState);

            var result = await _signInManager.PasswordSignInAsync(loginUser.Name, loginUser.Password, false, true);

            if (result.Succeeded)
            {
                var tokeResponse = createToken(loginUser.Name);
                return CustomResponse(tokeResponse);
            }

            if (result.IsLockedOut)
            {
                AddError("This user is blocked");
                return CustomResponse();
            }

            AddError("Incorrect user or password");
            return CustomResponse();
        }

        private CustomUserResponse createToken(string name)
        {
            return new CustomJwtBuilder<MyIdentityUser>()
                .WithUserManager(_userManager)
                .WithJwtSettings(_appJwtSettings)
                .WithName(name)
                .WithUserClaims()
                .WithJwtClaims()
                .WithUserRoles()
                .BuildCustomUserResponse<CustomUserResponse>(createCustomResponse);
        }

        private CustomUserResponse createCustomResponse(MyIdentityUser user, IEnumerable<UserClaim> claims, CustomToken token)
        {
            var response = new CustomUserResponse
            {
                AccessToken = token.AccessToken,
                TokenType = token.tokenType,
                ExpiresIn = token.ExpiresIn,
                UserToken = new CustomUserToken
                {
                    Id = user.Id,
                    Email = user.Email,
                    Name = user.UserName,
                    Claims = claims
                }
            };
            return response;
        }
    }
}