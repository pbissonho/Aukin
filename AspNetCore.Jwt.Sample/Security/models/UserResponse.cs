using System.Collections.Generic;
using NetDevPack.Identity.Jwt.Model;

namespace AspNetCore.Jwt.Sample.Security.models
{

    public class CustomUserResponse
    {
        public string AccessToken { get; set; }
        public double ExpiresIn { get; set; }
        public string TokenType { get; set; }
        public CustomUserToken UserToken { get; set; }
    }

    public class CustomUserToken
    {
        public string Id { get; set; }
        public string Email { get; set; }
        public string Name { get; set; }
        public IEnumerable<UserClaim> Claims { get; set; }
    }
}