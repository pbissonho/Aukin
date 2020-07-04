namespace AspNetCore.Jwt.Sample.Security.models
{
    public class CustomToken
    {
        public string AccessToken { get; set; }
        public double ExpiresIn { get; set; }
        public string tokenType { get; set; }
    }
}