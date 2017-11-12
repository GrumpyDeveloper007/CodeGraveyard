
ATLLogAppps.dll: dlldata.obj ATLLogApp_p.obj ATLLogApp_i.obj
	link /dll /out:ATLLogAppps.dll /def:ATLLogAppps.def /entry:DllMain dlldata.obj ATLLogApp_p.obj ATLLogApp_i.obj \
		kernel32.lib rpcndr.lib rpcns4.lib rpcrt4.lib oleaut32.lib uuid.lib \

.c.obj:
	cl /c /Ox /DWIN32 /D_WIN32_WINNT=0x0400 /DREGISTER_PROXY_DLL \
		$<

clean:
	@del ATLLogAppps.dll
	@del ATLLogAppps.lib
	@del ATLLogAppps.exp
	@del dlldata.obj
	@del ATLLogApp_p.obj
	@del ATLLogApp_i.obj
