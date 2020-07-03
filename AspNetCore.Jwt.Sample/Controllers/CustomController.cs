using AspNetCore.Jwt.Sample.Config;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NetDevPack.Identity.Authorization;
using NetDevPack.Identity.User;

namespace AspNetCore.Jwt.Sample.Controllers
{
    [Authorize]
    [Authorize(Roles = Roles.ROLE_BASIC)]
    [Route("api/sample")]
    public class SampleController : CustomController
    {
        private readonly IAspNetUser _user;

        public SampleController(IAspNetUser user)
        {
            _user = user;
        }

        [HttpGet("read")]
        public IActionResult SampleActionRead()
        {
            return CustomResponse($"The user {_user.GetUserEmail()} have permission to get this!");
        }

        [HttpGet("list")]
        [CustomAuthorize("Sample", "List")]
        public IActionResult SampleActionList()
        {
            return CustomResponse($"The user {_user.GetUserEmail()} have permission to get this!");
        }
    }
}