
atltestps.dll: dlldata.obj atltest_p.obj atltest_i.obj
	link /dll /out:atltestps.dll /def:atltestps.def /entry:DllMain dlldata.obj atltest_p.obj atltest_i.obj \
		kernel32.lib rpcndr.lib rpcns4.lib rpcrt4.lib oleaut32.lib uuid.lib \

.c.obj:
	cl /c /Ox /DWIN32 /D_WIN32_WINNT=0x0400 /DREGISTER_PROXY_DLL \
		$<

clean:
	@del atltestps.dll
	@del atltestps.lib
	@del atltestps.exp
	@del dlldata.obj
	@del atltest_p.obj
	@del atltest_i.obj
