using System.Collections.Generic;
using System.Linq;
using AspNetCore.Jwt.Sample.Controllers.Error;
using FluentValidation.Results;
using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Mvc.ModelBinding;
using Newtonsoft.Json;

namespace AspNetCore.Jwt.Sample.Controllers
{
    public static class ErrorFormat
    {
        public static string SerializeError(ModelStateDictionary modelState, ApiError apiError)
        {
            var errors = modelState.Values.SelectMany(e => e.Errors);

            foreach (var error in errors)
            {
                apiError.AddMessage(error.ErrorMessage);
            }

            string json = JsonConvert.SerializeObject(apiError, Formatting.Indented);
            return json;
        }

        public static string SerializeError(ApiError apiError)
        {
            string json = JsonConvert.SerializeObject(apiError, Formatting.Indented);
            return json;
        }
    }
}