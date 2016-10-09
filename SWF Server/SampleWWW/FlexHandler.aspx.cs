using System;
using System.Data;
using System.Configuration;
using System.Collections;
using System.Web;
using System.Web.UI;
using Kamacho.DNF.AMF;
using System.Threading;

public partial class FlexHandler : System.Web.UI.Page
{
    //reference to our processor
    private AMFProcessor _processor;

    protected void Page_Load(object sender, EventArgs e)
    {
        //initialize the processor to handle the HttpRequest as the input stream
        //and the HttpResponse as the output stream
        _processor = new AMFProcessor(this.Request, this.Response);

        //sets the event handler that will process the incoming requests
        _processor.Command += new AMFProcessor.AMFCommandHandler(_processor_Command);
        
        //tells the processor to handle the request and output the results to the 
        //HttpResponse object
        _processor.ProcessHttpRequest();
    }

    //is called by the AMFProcessor when it is ready to receive an output value
    //for a request from the client
    void _processor_Command(AMFClientRequest request)
    {
        switch (request.Command)
        {
            case "LoadProfile":
                LoadProfile(request);
                break;
            case "LoadInvoice":
                LoadInvoiceForUser(request);
                break;
        }
    }

    //example of returning a typed object
    private void LoadProfile(AMFClientRequest request)
    {
        //get the profile id from the parameters sent in by the client
        string profileId = request.GetString(0);

        //normally you would call some component to load a profile object
        //but in this case we will just initialize one
        ProfileDTO profile = new ProfileDTO();
        profile.Id = profileId;
        profile.Name = "Sample User";
        profile.Email = "suser@samples.com";

        //set the response object to our DTO so we can use it on the client
        request.Response = profile;
    }

    //example of returning a generic action script object
    private void LoadInvoiceForUser(AMFClientRequest request)
    {
        //get the current user id, since this page is in our normal ASP.NET application
        //we have access to anything in our normal AppDomain, including our security 
        //whether we our using Cookies, Sessions, etc....
        //this way we let our security mechanism handle user params and identity instead
        //of passing user id as a parameter on the wire
        string userId = Thread.CurrentPrincipal.Identity.Name;

        //create a generic action script container to return the profile of the current
        //user and the invoice requested
        ActionScriptObject aso = new ActionScriptObject();

        //again, normally you would be loading these up from another component
        ProfileDTO userProfile = new ProfileDTO();
        userProfile.Id = userId;
        userProfile.Name = "Current User";
        userProfile.Email = "someuser@samples.com";

        //add it to the action script object
        aso.AddProperty("user", AMFDataType.AMFEnabledObject, userProfile);

        //load up an invoice
        InvoiceDTO invoice = new InvoiceDTO();
        invoice.Id = Guid.NewGuid();

        //add it to the action script object
        aso.AddProperty("invoice", AMFDataType.AMFEnabledObject, invoice); 

        //add specific properties also
        aso.AddProperty("loaded", AMFDataType.Boolean, true);

        //set the response object
        request.Response = aso;
    }
}



