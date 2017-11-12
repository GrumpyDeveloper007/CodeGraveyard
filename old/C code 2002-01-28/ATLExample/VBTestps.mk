
VBTestps.dll: dlldata.obj VBTest_p.obj VBTest_i.obj
	link /dll /out:VBTestps.dll /def:VBTestps.def /entry:DllMain dlldata.obj VBTest_p.obj VBTest_i.obj kernel32.lib rpcndr.lib rpcns4.lib rpcrt4.lib oleaut32.lib uuid.lib 

.c.obj:
	cl /c /Ox /DWIN32 /D_WIN32_WINNT=0x0400 /DREGISTER_PROXY_DLL $<

clean:
	@del VBTestps.dll
	@del VBTestps.lib
	@del VBTestps.exp
	@del dlldata.obj
	@del VBTest_p.obj
	@del VBTest_i.obj
