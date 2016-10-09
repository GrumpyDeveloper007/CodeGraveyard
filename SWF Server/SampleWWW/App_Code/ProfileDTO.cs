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
/// Sample DTO object
/// </summary>
[AMFEnabled("Kamacho.Samples.DTO.ProfileDTO")]
public class ProfileDTO
{
    [AMFProperty(AMFDataType.String, "id")]
    public string Id;
    [AMFProperty(AMFDataType.String, "name")]
    public string Name;
    [AMFProperty(AMFDataType.String, "email")]
    public string Email;

    
    public ProfileDTO()
    {
       
    }
}
