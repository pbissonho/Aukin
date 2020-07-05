using System.Linq;
using System.Security.Cryptography;

namespace AspNetCore.Jwt.Sample.Security
{
    public class RandomGenerator
    {
        private const string AllowableCharacters = "0123456789";

        private const string AllowableCharactersToken = "QWERTYUIOPASDFGHJKLZXCVBNMqwertyuiopasdfghjlzxcvbnm,.;~][/01234567892!@#$%*()";


        public static string GenerateString(int length)
        {
            var bytes = new byte[length];

            using (var random = RandomNumberGenerator.Create())
            {
                random.GetBytes(bytes);
            }

            return new string(bytes.Select(x => AllowableCharacters[x % AllowableCharacters.Length]).ToArray());
        }

        public static string GenerateToken(int length)
        {
            var bytes = new byte[length];

            using (var random = RandomNumberGenerator.Create())
            {
                random.GetBytes(bytes);
            }

            return new string(bytes.Select(x => AllowableCharactersToken[x % AllowableCharacters.Length]).ToArray());
        }
    }
}