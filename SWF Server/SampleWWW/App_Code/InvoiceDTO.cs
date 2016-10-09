using System;
using System.Data;
using System.Configuration;
using System.Web;
using System.Web.Security;
using System.Web.UI;
using System.Web.UI.WebControls;
using System.Web.UI.WebControls.WebParts;
using System.Web.UI.HtmlControls;
using Kamacho.DNF.AMF;

/// <summary>
/// Sample DTO
/// </summary>
[AMFEnabled("Kamacho.Samples.DTO.InvoiceDTO")]
public class InvoiceDTO
{
    [AMFProperty(AMFDataType.Guid, "id")]
    public Guid Id;

    public InvoiceDTO()
    {
        
    }
}
