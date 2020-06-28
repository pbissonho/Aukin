using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Authorization;
using APIProdutos.Security;
using System.Threading.Tasks;

namespace APIProdutos.Controllers
{
    [ApiController]
    [Route("[controller]")]
    public class AuthController : ControllerBase
    {

        private readonly AccessManager _accessManager;

        public AuthController(AccessManager accessManager)
        {
            _accessManager = accessManager;
        }

        [AllowAnonymous]
        [HttpPost("Login")]
        public async Task<object> LogIn(
           [FromBody] AccessCredentials credenciais)
        {
            if (_accessManager.ValidateLogInWithPassword(credenciais))
            {
                return await _accessManager.GenerateTokenAsync(credenciais);
            }
            else
            {
                return new
                {
                    Authenticated = false,
                    Message = "Falha ao autenticar."
                };
            }
        }

        [AllowAnonymous]
        [HttpPost("refresh_token")]
        public async Task<object> RefreshToken(
            [FromBody] AccessCredentials credenciais
            )
        {
            if (_accessManager.ValidateRefreshTokenCredentials(credenciais))
            {
                return await _accessManager.GenerateTokenAsync(credenciais, );
            }
            else
            {
                return new
                {
                    Authenticated = false,
                    Message = "Falha ao atualizar o token."
                };
            }
        }

        [AllowAnonymous]
        [HttpPost("Signup")]
        public object SignUp(
            [FromBody] RegisterCredentials credenciais,
            [FromServices] AccessManager accessManager)
        {
            try
            {
                accessManager.signUp(credenciais);
                return Ok();
            }
            catch (System.Exception)
            {

                return new
                {
                    Registered = false,
                    Message = "Falha ao cadastrar."
                };
            }

        }
    }
}