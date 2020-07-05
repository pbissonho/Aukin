using AspNetCore.Jwt.Sample.Config;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using NetDevPack.Identity.Authorization;
using NetDevPack.Identity.User;

namespace AspNetCore.Jwt.Sample.Controllers
{   
    [ApiController]
    [Authorize]
    [Authorize(Roles = Roles.BASIC)]
    [Route("api/sample")]
    public class SampleController : ControllerBase
    {
        private readonly IAspNetUser _user;

        public SampleController(IAspNetUser user)
        {
            _user = user;
        }

        [HttpGet("read")]
        [CustomAuthorize(Claims.Sample, ClaimsValues.READ)]
        public IActionResult SampleActionRead()
        {   var name = _user.Name;
            return Ok($"The user {name} have permission to get this!");
        }

        [HttpPost("write")]
        [CustomAuthorize(Claims.Sample, ClaimsValues.WRITE)]
        public IActionResult SampleActionWrite()
        {
            return Ok($"The user {_user.GetUserEmail()} have permission to do this.!");
        }
    }
}