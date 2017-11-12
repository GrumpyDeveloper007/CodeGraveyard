
ELFLIBps.dll: dlldata.obj ELFLIB_p.obj ELFLIB_i.obj
	link /dll /out:ELFLIBps.dll /def:ELFLIBps.def /entry:DllMain dlldata.obj ELFLIB_p.obj ELFLIB_i.obj \
		kernel32.lib rpcndr.lib rpcns4.lib rpcrt4.lib oleaut32.lib uuid.lib \

.c.obj:
	cl /c /Ox /DWIN32 /D_WIN32_WINNT=0x0400 /DREGISTER_PROXY_DLL \
		$<

clean:
	@del ELFLIBps.dll
	@del ELFLIBps.lib
	@del ELFLIBps.exp
	@del dlldata.obj
	@del ELFLIB_p.obj
	@del ELFLIB_i.obj
