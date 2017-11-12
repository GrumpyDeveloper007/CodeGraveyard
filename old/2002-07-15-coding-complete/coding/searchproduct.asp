
<HTML>
<HEAD>
<META NAME="GENERATOR" Content="Microsoft Visual Studio 6.0">
</HEAD>
<BODY>

<P>&nbsp;</P>
<SCRIPT LANGUAGE=vbscript RUNAT=Server>

 dim db
 dim prodname 
 set db=server.createobject("ADODB.connection")
 db.Mode =admodereadwrite
 
  db.open("Driver={Microsoft Access Driver (*.mdb)};Dbq=e:\domains\pyrodesign.co.uk\user\htdocs\aftersales.mdb;Uid=Admin;Pwd=;")
                   
 set rs=server.createobject("ADODB.recordset")
 prodname=ucase(request.form("Name"))
 Set RS = db.Execute("SELECT * FROM parts WHERE description LIKE '" & prodname & "%' order by description") 

 'Set RS = db.Execute("SELECT * FROM parts order by description ") 
 if (rs.eof=false) then
  do while (rs.eof=false)
    response.write(rs.fields("description"))
    response.write("<HR>")
    rs.movenext
  loop
 else
 end if
</SCRIPT>

</BODY>
</HTML>
