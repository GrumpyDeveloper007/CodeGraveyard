
DialogAppps.dll: dlldata.obj DialogApp_p.obj DialogApp_i.obj
	link /dll /out:DialogAppps.dll /def:DialogAppps.def /entry:DllMain dlldata.obj DialogApp_p.obj DialogApp_i.obj kernel32.lib rpcndr.lib rpcns4.lib rpcrt4.lib oleaut32.lib uuid.lib 

.c.obj:
	cl /c /Ox /DWIN32 /D_WIN32_WINNT=0x0400 /DREGISTER_PROXY_DLL $<

clean:
	@del DialogAppps.dll
	@del DialogAppps.lib
	@del DialogAppps.exp
	@del dlldata.obj
	@del DialogApp_p.obj
	@del DialogApp_i.obj
