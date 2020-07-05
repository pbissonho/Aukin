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
using AspNetCore.Jwt.Sample.EmailService;
using AspNetCore.Jwt.Sample.EmailService.models;
using Microsoft.Extensions.Caching.Memory;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Http.Features;
using System;

namespace AspNetCore.Jwt.Sample.Controllers
{
    [ApiController]
    [Route("api/account")]
    public class AccountController : ControllerBase
    {
        private readonly SignInManager<MyIdentityUser> _signInManager;
        private readonly UserManager<MyIdentityUser> _userManager;
        private readonly AppJwtSettings _appJwtSettings;

        private readonly IEmailSender _emailService;

        public AccountController(SignInManager<MyIdentityUser> signInManager,
            UserManager<MyIdentityUser> userManager,
            IEmailSender emailService,
            IOptions<AppJwtSettings> appJwtSettings)
        {
            _emailService = emailService;
            _signInManager = signInManager;
            _userManager = userManager;
            _appJwtSettings = appJwtSettings.Value;
        }


        [HttpPost("send")]
        public async Task<ActionResult> ForgotPassword(ForgotPasswordModel model, [FromServices] IMemoryCache cache)
        {

            var user = await _userManager.FindByEmailAsync(model.Email);

            if (user == null)
            {
                string jsonError = ErrorFormat.SerializeError(new BadRequestError("The email address does not exist."));
                return BadRequest(jsonError);
            }

            var token = await _userManager.GeneratePasswordResetTokenAsync(user);
            var code = RandomGenerator.GenerateString(8);
            cache.Set(code, token);

            await _emailService.SendEmailAsync(model.Email, "Reset password account.", "Code:" + code);

            return Ok();

        }

        [HttpPost("reset")]
        public async Task<ActionResult> ResetPassword(ResetPasswordModel model, [FromServices] IMemoryCache cache)
        {
            var user = await _userManager.FindByEmailAsync(model.Email);

            if (user == null)
            {
                return BadRequest(ErrorFormat.SerializeError(new BadRequestError("Invalid reset credentiais")));
            }

            await _userManager.ResetPasswordAsync(user, model.Token, model.Password);
            return Ok("Ok");
        }

        [HttpPost("reset-token")]
        public async Task<ActionResult> ResetAcessTokenPassword(ResetTokenPasswordModel model, [FromServices] IMemoryCache cache)
        {
            string jsonError = ErrorFormat.SerializeError(new BadRequestError("Invalid reset credentiais"));
            var user = await _userManager.FindByEmailAsync(model.Email);

            if (user == null)
            {
                return BadRequest(jsonError);
            }

            var lockoutEndDate = await _userManager.GetLockoutEndDateAsync(user);

            if (lockoutEndDate > DateTimeOffset.Now)
            {
                return BadRequest(ErrorFormat.SerializeError(new BadRequestError("Too many attempts to reset. Wait a few minutes and try again")));
            }

            var token = cache.Get(model.Code) as string;

            if (token == null)
            {

                var time = DateTimeOffset.Now.AddSeconds(30);
                await _userManager.SetLockoutEndDateAsync(user, time);
                var error = new BadRequestError();
                return BadRequest(jsonError);
            }
            //await _userManager.ResetPasswordAsync(user, token, model.Password);
            return Ok(new ResetAcessTokenPasswordModel(token));
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
                await _userManager.AddToRoleAsync(user, Roles.BASIC);
                await _userManager.AddClaimAsync(user, new Claim(Claims.Sample, ClaimsValues.READ));
                await _userManager.AddClaimAsync(user, new Claim(Claims.Sample, ClaimsValues.WRITE));
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