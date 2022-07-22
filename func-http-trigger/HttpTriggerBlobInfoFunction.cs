using System.IO;
using System.Net;
using System.Threading.Tasks;
using Azure.Storage.Blobs;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Azure.WebJobs;
using Microsoft.Azure.WebJobs.Extensions.Http;
using Microsoft.Azure.WebJobs.Extensions.OpenApi.Core.Attributes;
using Microsoft.Extensions.Logging;
using Azure.Storage.Blobs.Models;
using Microsoft.OpenApi.Models;
using Newtonsoft.Json;

namespace msft.function
{
    public class HttpTriggerBlobInfoFunction
    {
        private readonly ILogger<HttpTriggerBlobInfoFunction> _logger;

        public HttpTriggerBlobInfoFunction(ILogger<HttpTriggerBlobInfoFunction> log)
        {
            _logger = log;
        }

        [FunctionName("HttpTriggerBlobInfoFunction")]
        [OpenApiOperation(operationId: "Run", tags: new[] { "name" })]
        [OpenApiParameter(name: "name", In = ParameterLocation.Query, Required = true, Type = typeof(string), Description = "The **Name** of the container parameter")]
        [OpenApiResponseWithBody(statusCode: HttpStatusCode.OK, contentType: "text/plain", bodyType: typeof(string), Description = "The OK response")]
        public async Task<IActionResult> Run(
            [HttpTrigger(AuthorizationLevel.Anonymous, "get", "post", Route = null)] HttpRequest req,
            [Blob("test")] BlobContainerClient blobContainerClient)
        {
            _logger.LogInformation("C# HTTP trigger function processed a request.");

            string name = req.Query["name"];

            string requestBody = await new StreamReader(req.Body).ReadToEndAsync();
            dynamic data = JsonConvert.DeserializeObject(requestBody);
            name = name ?? data?.name;

            string responseMessage = "Hello " + name + "!\n";

            await foreach (BlobItem blobItem in blobContainerClient.GetBlobsAsync())
            {
                responseMessage += blobItem.Name + "\n";
            }

            return new OkObjectResult(responseMessage);
        }
    }
}

