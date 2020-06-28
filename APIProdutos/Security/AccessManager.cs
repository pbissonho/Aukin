using System;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Principal;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using Microsoft.Extensions.Caching.Distributed;
using Newtonsoft.Json;
using APIProdutos.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace APIProdutos.Security
{
    public class AccessManager
    {
        private UserManager<ApplicationUser> _userManager;
        private SignInManager<ApplicationUser> _signInManager;
        private SigningConfigurations _signingConfigurations;
        private TokenConfigurations _tokenConfigurations;
        private readonly RoleManager<IdentityRole> _roleManager;

        public AccessManager(
            UserManager<ApplicationUser> userManager,
            SignInManager<ApplicationUser> signInManager,
            SigningConfigurations signingConfigurations,
            TokenConfigurations tokenConfigurations,
            RoleManager<IdentityRole> roleManager
           // IDistributedCache cache
           )
        {
            _userManager = userManager;
            _signInManager = signInManager;
            _signingConfigurations = signingConfigurations;
            _tokenConfigurations = tokenConfigurations;
            _roleManager = roleManager;
            // _cache = cache;
        }

        public void signUp(RegisterCredentials credenciais)
        {
            //método para registrar todas as roles do sistema
            List<string> roles = new List<string>();

            //Listagem de todas as roles da API!
            roles.Add(Roles.ROLE_ADMIN);
            roles.Add(Roles.ROLE_BASIC);
            roles.Add(Roles.ROLE_API_PRODUTOS);

            CreateUser(
                new ApplicationUser()
                {
                    UserName = credenciais.UserName,
                    Email = credenciais.UserEmail,
                    EmailConfirmed = true
                }, credenciais.Password, roles
            );
        }
        public void CreateUser(ApplicationUser user, string password, List<String> roles)
        {
            if (_userManager.FindByNameAsync(user.UserName).Result == null)
            {
                var createdResult = _userManager
                    .CreateAsync(user, password).Result;

                if (createdResult == null)
                {
                    throw new Exception($"Erro durante a criação do usuário.");
                }

                foreach (string role in roles)
                {
                    if (_roleManager.RoleExistsAsync(role).Result)
                    {
                        var result = _userManager.AddToRoleAsync(user, role).Result;
                        if (!result.Succeeded)
                        {
                            throw new Exception($"Erro durante a inserção da role {role}.");
                        }
                    }
                }

            }
            else
            {
                throw new Exception($"Erro durante a criação do usuário.");
            }
        }
        public bool ValidateLogInWithPassword(AccessCredentials credenciais)
        {
            bool credenciaisValidas = false;
            if (credenciais == null || String.IsNullOrWhiteSpace(credenciais.UserName)) return false;
            if (credenciais.GrantType != "password") return false;

            // Verifica a existência do usuário nas tabelas do
            // ASP.NET Core Identity
            var userIdentity = _userManager.FindByNameAsync(credenciais.UserName).Result;
            if (userIdentity == null) return false;

            // Efetua o login com base no Id do usuário e sua senha
            var resultadoLogin = _signInManager
                            .CheckPasswordSignInAsync(userIdentity, credenciais.Password, false)
                            .Result;
            if (resultadoLogin.Succeeded)
            {
                // Verifica se o usuário em questão possui
                // a role Acesso-APIProdutos
                credenciaisValidas = _userManager.IsInRoleAsync(
                    userIdentity, Roles.ROLE_API_PRODUTOS).Result;
            }

            return credenciaisValidas;
        }
        public bool ValidateRefreshTokenCredentials(AccessCredentials credenciais)
        {
            bool credenciaisValidas = false;
            if (credenciais != null && !String.IsNullOrWhiteSpace(credenciais.UserName)) return false;
            if (credenciais.GrantType != "refresh_token") return false;

            if (!String.IsNullOrWhiteSpace(credenciais.RefreshToken))
            {
                RefreshTokenData refreshTokenBase = RecoverRefreshToken(credenciais);

                credenciaisValidas = (refreshTokenBase != null &&
                    credenciais.UserName == refreshTokenBase.UserID &&
                    credenciais.RefreshToken == refreshTokenBase.RefreshToken);

                // if (credenciaisValidas)
                //   _cache.Remove(credenciais.RefreshToken);
            }

            return credenciaisValidas;
        }
        public async Task<Token> GenerateTokenAsync(AccessCredentials credenciais, ApplicationUser user)
        {
            var userIdentity = _userManager
                         .FindByNameAsync(credenciais.UserName).Result;
            var UserClams = await _userManager.GetRolesAsync(userIdentity);


            List<Claim> clams = new List<Claim>();
            clams.Add(new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString("N")));
            clams.Add(new Claim(JwtRegisteredClaimNames.UniqueName, user.UserName));
            clams.Add(new Claim(JwtRegisteredClaimNames.Email, user.Email));

            foreach (var clamString in UserClams)
            {
                clams.Add(new Claim(ClaimTypes.Role, clamString));
            }

            ClaimsIdentity identity = new ClaimsIdentity(
                new GenericIdentity(credenciais.UserName, "Login"),
                clams
            );

            DateTime dataCriacao = DateTime.Now;
            DateTime dataExpiracao = dataCriacao +
                TimeSpan.FromSeconds(_tokenConfigurations.Seconds);

            var handler = new JwtSecurityTokenHandler();

            var securityToken = handler.CreateToken(new SecurityTokenDescriptor
            {
                Issuer = _tokenConfigurations.Issuer,
                Audience = _tokenConfigurations.Audience,
                SigningCredentials = _signingConfigurations.SigningCredentials,
                Subject = identity,
                NotBefore = dataCriacao,
                Expires = dataExpiracao
            });

            var token = handler.WriteToken(securityToken);

            var resultado = new Token()
            {
                Authenticated = true,
                Created = dataCriacao.ToString("yyyy-MM-dd HH:mm:ss"),
                Expiration = dataExpiracao.ToString("yyyy-MM-dd HH:mm:ss"),
                AccessToken = token,
                RefreshToken = Guid.NewGuid().ToString().Replace("-", String.Empty),
                Message = "OK"
            };


            //  GenerateRefreshToken(resultado, credenciais);
            return resultado;
        }
        public RefreshTokenData RecoverRefreshToken(AccessCredentials credenciais)
        {
            RefreshTokenData refreshTokenBase = null;

            string strTokenArmazenado = "";
            // _cache.GetString(credenciais.RefreshToken);
            if (!String.IsNullOrWhiteSpace(strTokenArmazenado))
            {
                refreshTokenBase = JsonConvert
                    .DeserializeObject<RefreshTokenData>(strTokenArmazenado);
            }

            return refreshTokenBase;
        }
        public RefreshTokenData GenerateRefreshToken(Token token, AccessCredentials credenciais)
        {
            var refreshTokenData = new RefreshTokenData();
            refreshTokenData.RefreshToken = token.RefreshToken;
            refreshTokenData.UserID = credenciais.UserName;

            return refreshTokenData;

            /*
            var finalExpiration = TimeSpan.FromSeconds(_tokenConfigurations.FinalExpiration);

            DistributedCacheEntryOptions opcoesCache =
                new DistributedCacheEntryOptions();
            opcoesCache.SetAbsoluteExpiration(finalExpiration);

            _cache.SetString(token.RefreshToken,
                JsonConvert.SerializeObject(refreshTokenData),
                opcoesCache);*/
        }
    }
}