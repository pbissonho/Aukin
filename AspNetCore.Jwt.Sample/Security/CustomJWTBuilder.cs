using System;
using System.Collections.Generic;
using System.IdentityModel.Tokens.Jwt;
using System.Linq;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Identity;
using Microsoft.IdentityModel.Tokens;
using NetDevPack.Identity.Jwt.Model;
using NetDevPack.Identity.Jwt;
using AspNetCore.Jwt.Sample.Security.models;

namespace AspNetCore.Jwt.Sample.Security
{
    public class CustomJwtBuilder<TIdentityUser>
        where TIdentityUser : IdentityUser

    {
        private UserManager<TIdentityUser> _userManager;
        private AppJwtSettings _appJwtSettings;
        private TIdentityUser _user;
        private ICollection<Claim> _userClaims;
        private ICollection<Claim> _jwtClaims;
        private ClaimsIdentity _identityClaims;

        public CustomJwtBuilder<TIdentityUser> WithUserManager(UserManager<TIdentityUser> userManager)
        {
            _userManager = userManager ?? throw new ArgumentException(nameof(userManager));
            return this;
        }

        public CustomJwtBuilder<TIdentityUser> WithJwtSettings(AppJwtSettings appJwtSettings)
        {
            _appJwtSettings = appJwtSettings ?? throw new ArgumentException(nameof(appJwtSettings));
            return this;
        }

        public CustomJwtBuilder<TIdentityUser> WithName(string name)
        {
            if (string.IsNullOrEmpty(name)) throw new ArgumentException(nameof(name));

            _user = _userManager.FindByNameAsync(name).Result;
            _userClaims = new List<Claim>();
            _jwtClaims = new List<Claim>();
            _identityClaims = new ClaimsIdentity();

            return this;
        }

        public CustomJwtBuilder<TIdentityUser> WithJwtClaims()
        {
            _jwtClaims.Add(new Claim(JwtRegisteredClaimNames.Sub, _user.Id.ToString()));
            _jwtClaims.Add(new Claim(JwtRegisteredClaimNames.Email, _user.Email));
            _jwtClaims.Add(new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString()));
            _jwtClaims.Add(new Claim(JwtRegisteredClaimNames.Nbf, ToUnixEpochDate(DateTime.UtcNow).ToString()));
            _jwtClaims.Add(new Claim(JwtRegisteredClaimNames.Iat, ToUnixEpochDate(DateTime.UtcNow).ToString(), ClaimValueTypes.Integer64));

            _identityClaims.AddClaims(_jwtClaims);

            return this;
        }

        public CustomJwtBuilder<TIdentityUser> WithUserClaims()
        {
            _userClaims = _userManager.GetClaimsAsync(_user).Result;

            _identityClaims.AddClaims(_userClaims);

            return this;
        }

        public CustomJwtBuilder<TIdentityUser> WithUserRoles()
        {
            var userRoles = _userManager.GetRolesAsync(_user).Result;
            userRoles.ToList().ForEach(r => _identityClaims.AddClaim(new Claim("role", r)));

            return this;
        }
        public string BuildToken()
        {
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = Encoding.ASCII.GetBytes(_appJwtSettings.SecretKey);
            var token = tokenHandler.CreateToken(new SecurityTokenDescriptor
            {
                Issuer = _appJwtSettings.Issuer,
                Audience = _appJwtSettings.Audience,
                Subject = _identityClaims,
                Expires = DateTime.UtcNow.AddHours(_appJwtSettings.Expiration),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(key),
                    SecurityAlgorithms.HmacSha256Signature)
            });

            return tokenHandler.WriteToken(token);
        }

        public CustomUserResponse BuildUserResponse()
        {
            var user = new CustomUserResponse
            {
                AccessToken = BuildToken(),
                ExpiresIn = TimeSpan.FromHours(_appJwtSettings.Expiration).TotalSeconds,
                UserToken = new CustomUserToken
                {
                    Id = _user.Id,
                    Email = _user.Email,
                    Name = _user.NormalizedUserName,
                    Claims = _userClaims.Select(c => new UserClaim { Type = c.Type, Value = c.Value })
                }
            };

            return user;
        }


        public TResponse BuildCustomUserResponse<TResponse>(Func<TIdentityUser, IEnumerable<UserClaim>, CustomToken, TResponse> outraFuncao)
        {
            var clams = _userClaims.Select(c => new UserClaim { Type = c.Type, Value = c.Value });

            var token = new CustomToken
            {
                AccessToken = BuildToken(),
                ExpiresIn = TimeSpan.FromHours(_appJwtSettings.Expiration).TotalSeconds,
                tokenType = "bearer"
            };
            return outraFuncao(_user, clams, token);
        }


        private static long ToUnixEpochDate(DateTime date)
            => (long)Math.Round((date.ToUniversalTime() - new DateTimeOffset(1970, 1, 1, 0, 0, 0, TimeSpan.Zero))
                .TotalSeconds);
    }
}