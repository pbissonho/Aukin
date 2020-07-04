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
using AspNetCore.Jwt.Sample.Controllers.Error;
using Newtonsoft.Json;

namespace AspNetCore.Jwt.Sample.Controllers
{
    [ApiController]
    [Route("api/account")]
    public class AuthController : ControllerBase
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
                return Ok(createToken(user.UserName));
            }
            else
            {
                var error = new BadRequestError();
                foreach (var item in result.Errors)
                {
                    error.AddMessage(item.Description);
                }
                var json = ErrorFormat.SerializeError(ModelState, error);
                return BadRequest(json);
            }
        }

        [HttpPost("login")]
        public async Task<ActionResult> Login(CustomLoginUser loginUser)
        {

            var result = await _signInManager.PasswordSignInAsync(loginUser.Name, loginUser.Password, false, true);

            if (result.Succeeded)
            {
                var tokeResponse = createToken(loginUser.Name);
                return Ok(tokeResponse);
            }

            if (result.IsLockedOut)
            {
                string jsonError = ErrorFormat.SerializeError(new BadRequestError("Incorrect user or password"));
                return BadRequest(jsonError);
            }

            string json = ErrorFormat.SerializeError(new BadRequestError("Incorrect user or password"));
            return BadRequest(json);
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