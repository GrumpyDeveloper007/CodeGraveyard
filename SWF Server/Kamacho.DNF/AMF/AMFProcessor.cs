using System;
using System.Collections.Generic;
using System.Text;
using System.Web;
using System.IO;

namespace Kamacho.DNF.AMF
{
    /// <summary>
    /// The AMFProcessor is responsible for reading an AMF request from a Flash client, allowing
    /// other components to operate on the request, and returning the results to a Flash client.
    /// </summary>
    /// <example>
    
    /// </example>
	public class AMFProcessor
	{
		protected HttpRequest _request;
		protected HttpResponse _response;
		protected AMFEnvelope _envelope;
        protected List<AMFClientRequest> _clientRequests = new List<AMFClientRequest>();

        /// <summary>
        /// Handler signature that any component needs to implement in order to act on a request from
        /// a Flash client.  Your component will be handed an AMFClientRequest object and
        /// be expected to set the Response property of the request to a value that can
        /// be serialized in to an AMF format.
        /// </summary>
        /// <param name="request"></param>
		public delegate void AMFCommandHandler(AMFClientRequest request);

        /// <summary>
        /// The event that must be handled in your component in order to receive the request
        /// being called from the Flash client
        /// </summary>
		public event AMFCommandHandler Command;

        /// <summary>
        /// Constructor that should be used when you are using an ASP.NET web page as the
        /// destination for your AMF calls from your Flash client.  The AMFProcessor can
        /// be called anywhere within your page logic, or you can create your own HttpModule
        /// that calls the AMFProcessor as part of your overall Application framework.
        /// </summary>
        /// <param name="request"></param>
        /// <param name="response"></param>
		public AMFProcessor(HttpRequest request, HttpResponse response)
		{
			_request = request;
			_response = response;
		}

        /// <summary>
        /// Constructor that should be used if you want to use the processor outside
        /// of an Http framework and want to control what streams are being used for the 
        /// input (request) and output (response).  
        /// </summary>
        public AMFProcessor()
        {
        }

        /// <summary>
        /// Tells the AMFProcessor to immediately begin processing the AMF request on the input
        /// stream and to format the response on the output stream.  During this method execution, the
        /// AMFProcessor will raise the Command event and give your code a chance to set the Response
        /// property for the request(s).  If you do not send the outputStream to this call, you can
        /// have the results rendered later by calling RenderResponse.
        /// 
        /// If you are using the AMFProcessor for Http processing, you should call ProcessHttpRequest
        /// instead of this method and let the processor take care of the stream handling for you.
        /// </summary>
        /// <param name="inputStream"></param>
        /// <param name="outputStream"></param>
        public void ProcessRequest(Stream inputStream, Stream outputStream)
        {
            //read the incoming
            AMFReader reader = new AMFReader(inputStream);
            _envelope = reader.ReadRequest();

            //for each body that we have, prepare a response
            for (int i = 0; i < _envelope.Bodies.Count; i++)
            {
                AMFBody body = _envelope.Bodies[i];
                AMFClientRequest flexRequest = new AMFClientRequest();
                flexRequest.Command = body.Target;
                flexRequest.Id = body.ResponseId;
                flexRequest.Parameters = body.Value;
                flexRequest.Headers = _envelope.Headers;

                if (Command != null)
                    Command(flexRequest);

                _clientRequests.Add(flexRequest);
            }

            //now render the result
            if (outputStream != null)
                RenderResponse(outputStream);
        }

        /// <summary>
        /// If you are using the AMFProcessor for an Http request, call this method
        /// to process the request, write the response, and end the current HttpResponse
        /// </summary>
        public void ProcessHttpRequest()
        {
            ProcessHttpRequest(true);
        }

        /// <summary>
        /// If you are using the AMFProcessor for an Http request, call this method
        /// to process the request, and then optionally write the response and 
        /// end the current HttpResponse.  If you do not want to render the response
        /// you can call RenderHttpResponse later
        /// </summary>
        /// <param name="renderResponse"></param>
		public void ProcessHttpRequest(bool renderResponse)
		{
            //process the request
            ProcessRequest(_request.InputStream, null);

			//now render the result
            if (renderResponse)
                RenderHttpResponse();
		}

        /// <summary>
        /// Call this method if you did not want the AMFProcessor to automatically
        /// render the response from your previous call.  This will end the current
        /// HttpResponse
        /// </summary>
		public void RenderHttpResponse()
		{
			_response.ClearContent();

            RenderResponse(_response.OutputStream);

			_response.End();
		}

        /// <summary>
        /// Call this method to tell the AMFProcessor you are done processing the 
        /// client requests and ready for it to write the results to the output
        /// stream.  Only call this method if you did not send an output stream
        /// to the ProcessRequest method (normally used in an asynchronous situation)
        /// </summary>
        /// <param name="outputStream"></param>
        public void RenderResponse(Stream outputStream)
        {
            for (int i = 0; i < _envelope.Bodies.Count; i++)
            {
                AMFClientRequest flexRequest = _clientRequests[i];
                AMFBody body = _envelope.Bodies[i];

                //set the responses
                if (flexRequest.Response != null)
                    body.ReturnValue = flexRequest.Response;
            }

            AMFWriter writer = new AMFWriter(outputStream, _envelope);
            writer.WriteResponse();
        }
	}
}
