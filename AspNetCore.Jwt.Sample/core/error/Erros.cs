using System.Collections.Generic;
using System.Net;
using Newtonsoft.Json;

namespace AspNetCore.Jwt.Sample.Controllers.Error
{
    public class ApiError
    {
        public int StatusCode { get; private set; }
        public string StatusDescription { get; private set; }

        [JsonProperty(DefaultValueHandling = DefaultValueHandling.Ignore)]

        public IList<string> Messages = new List<string>();

        public void AddMessage(string erro)
        {
            Messages.Add(erro);
        }

        public ApiError(int statusCode, string statusDescription)
        {
            this.StatusCode = statusCode;
            this.StatusDescription = statusDescription;
        }

        public ApiError(int statusCode, string statusDescription, List<string> messages)
            : this(statusCode, statusDescription)
        {
            this.Messages = messages;
        }
    }

    public class InternalServerError : ApiError
    {
        public InternalServerError()
            : base(500, HttpStatusCode.InternalServerError.ToString())
        {
        }


        public InternalServerError(List<string> messages)
            : base(500, HttpStatusCode.InternalServerError.ToString(), messages)
        {
        }


    }
    public class NotFoundError : ApiError
    {
        public NotFoundError()
            : base(404, HttpStatusCode.NotFound.ToString())
        {
        }


        public NotFoundError(List<string> messages)
            : base(404, HttpStatusCode.NotFound.ToString(), messages)
        {
        }
    }
    public class BadRequestError : ApiError
    {
        public BadRequestError()
            : base(400, HttpStatusCode.BadRequest.ToString())
        {
        }

        public BadRequestError(List<string> messages)
            : base(400, HttpStatusCode.BadRequest.ToString(), messages)
        {
        }

        public BadRequestError(string message)
            : base(400, HttpStatusCode.BadRequest.ToString())
        {
            Messages.Add(message);
        }
    }
}