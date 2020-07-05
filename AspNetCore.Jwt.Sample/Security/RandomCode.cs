using System.Linq;
using System.Security.Cryptography;

namespace AspNetCore.Jwt.Sample.Security
{
    public class RandomGenerator
    {
        private const string AllowableCharacters = "0123456789QWERTYUIOPASDFGHJKLZXCVBNMqw01234567989ertyuiopasdfghjklzxcvbnm01234";

        public static string GenerateString(int length)
        {
            var bytes = new byte[length];

            using (var random = RandomNumberGenerator.Create())
            {
                random.GetBytes(bytes);
            }

            return new string(bytes.Select(x => AllowableCharacters[x % AllowableCharacters.Length]).ToArray());
        }
    }
}