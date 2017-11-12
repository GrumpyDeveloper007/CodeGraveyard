
ATLClientForTracerps.dll: dlldata.obj ATLClientForTracer_p.obj ATLClientForTracer_i.obj
	link /dll /out:ATLClientForTracerps.dll /def:ATLClientForTracerps.def /entry:DllMain dlldata.obj ATLClientForTracer_p.obj ATLClientForTracer_i.obj \
		kernel32.lib rpcndr.lib rpcns4.lib rpcrt4.lib oleaut32.lib uuid.lib \

.c.obj:
	cl /c /Ox /DWIN32 /D_WIN32_WINNT=0x0400 /DREGISTER_PROXY_DLL \
		$<

clean:
	@del ATLClientForTracerps.dll
	@del ATLClientForTracerps.lib
	@del ATLClientForTracerps.exp
	@del dlldata.obj
	@del ATLClientForTracer_p.obj
	@del ATLClientForTracer_i.obj
