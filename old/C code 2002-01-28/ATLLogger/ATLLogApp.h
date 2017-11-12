/* this ALWAYS GENERATED file contains the definitions for the interfaces */


/* File created by MIDL compiler version 5.01.0164 */
/* at Mon Jan 03 19:58:28 2000
 */
/* Compiler settings for C:\ArticleNo3\ATLLogApp\ATLLogApp.idl:
    Oicf (OptLev=i2), W1, Zp8, env=Win32, ms_ext, c_ext
    error checks: allocation ref bounds_check enum stub_data 
*/
//@@MIDL_FILE_HEADING(  )


/* verify that the <rpcndr.h> version is high enough to compile this file*/
#ifndef __REQUIRED_RPCNDR_H_VERSION__
#define __REQUIRED_RPCNDR_H_VERSION__ 440
#endif

#include "rpc.h"
#include "rpcndr.h"

#ifndef __RPCNDR_H_VERSION__
#error this stub requires an updated version of <rpcndr.h>
#endif // __RPCNDR_H_VERSION__

#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif /*COM_NO_WINDOWS_H*/

#ifndef __ATLLogApp_h__
#define __ATLLogApp_h__

#ifdef __cplusplus
extern "C"{
#endif 

/* Forward Declarations */ 

#ifndef __ICoLogger_FWD_DEFINED__
#define __ICoLogger_FWD_DEFINED__
typedef interface ICoLogger ICoLogger;
#endif 	/* __ICoLogger_FWD_DEFINED__ */


#ifndef __CoLogger_FWD_DEFINED__
#define __CoLogger_FWD_DEFINED__

#ifdef __cplusplus
typedef class CoLogger CoLogger;
#else
typedef struct CoLogger CoLogger;
#endif /* __cplusplus */

#endif 	/* __CoLogger_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

void __RPC_FAR * __RPC_USER MIDL_user_allocate(size_t);
void __RPC_USER MIDL_user_free( void __RPC_FAR * ); 

#ifndef __ICoLogger_INTERFACE_DEFINED__
#define __ICoLogger_INTERFACE_DEFINED__

/* interface ICoLogger */
/* [unique][helpstring][uuid][object] */ 


EXTERN_C const IID IID_ICoLogger;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("C82C8B65-C218-11D3-9739-0050047D51FB")
    ICoLogger : public IUnknown
    {
    public:
        virtual /* [helpstring] */ HRESULT STDMETHODCALLTYPE Initialize( void) = 0;
        
        virtual /* [helpstring] */ HRESULT STDMETHODCALLTYPE DisplayText( void) = 0;
        
        virtual /* [helpstring] */ HRESULT STDMETHODCALLTYPE Log( 
            /* [in] */ BSTR Message) = 0;
        
        virtual /* [helpstring] */ HRESULT STDMETHODCALLTYPE UnInitialize( void) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct ICoLoggerVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            ICoLogger __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            ICoLogger __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            ICoLogger __RPC_FAR * This);
        
        /* [helpstring] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Initialize )( 
            ICoLogger __RPC_FAR * This);
        
        /* [helpstring] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *DisplayText )( 
            ICoLogger __RPC_FAR * This);
        
        /* [helpstring] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Log )( 
            ICoLogger __RPC_FAR * This,
            /* [in] */ BSTR Message);
        
        /* [helpstring] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *UnInitialize )( 
            ICoLogger __RPC_FAR * This);
        
        END_INTERFACE
    } ICoLoggerVtbl;

    interface ICoLogger
    {
        CONST_VTBL struct ICoLoggerVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define ICoLogger_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define ICoLogger_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define ICoLogger_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define ICoLogger_Initialize(This)	\
    (This)->lpVtbl -> Initialize(This)

#define ICoLogger_DisplayText(This)	\
    (This)->lpVtbl -> DisplayText(This)

#define ICoLogger_Log(This,Message)	\
    (This)->lpVtbl -> Log(This,Message)

#define ICoLogger_UnInitialize(This)	\
    (This)->lpVtbl -> UnInitialize(This)

#endif /* COBJMACROS */


#endif 	/* C style interface */



/* [helpstring] */ HRESULT STDMETHODCALLTYPE ICoLogger_Initialize_Proxy( 
    ICoLogger __RPC_FAR * This);


void __RPC_STUB ICoLogger_Initialize_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring] */ HRESULT STDMETHODCALLTYPE ICoLogger_DisplayText_Proxy( 
    ICoLogger __RPC_FAR * This);


void __RPC_STUB ICoLogger_DisplayText_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring] */ HRESULT STDMETHODCALLTYPE ICoLogger_Log_Proxy( 
    ICoLogger __RPC_FAR * This,
    /* [in] */ BSTR Message);


void __RPC_STUB ICoLogger_Log_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring] */ HRESULT STDMETHODCALLTYPE ICoLogger_UnInitialize_Proxy( 
    ICoLogger __RPC_FAR * This);


void __RPC_STUB ICoLogger_UnInitialize_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __ICoLogger_INTERFACE_DEFINED__ */



#ifndef __ATLLOGAPPLib_LIBRARY_DEFINED__
#define __ATLLOGAPPLib_LIBRARY_DEFINED__

/* library ATLLOGAPPLib */
/* [helpstring][version][uuid] */ 


EXTERN_C const IID LIBID_ATLLOGAPPLib;

EXTERN_C const CLSID CLSID_CoLogger;

#ifdef __cplusplus

class DECLSPEC_UUID("C82C8B66-C218-11D3-9739-0050047D51FB")
CoLogger;
#endif
#endif /* __ATLLOGAPPLib_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

unsigned long             __RPC_USER  BSTR_UserSize(     unsigned long __RPC_FAR *, unsigned long            , BSTR __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  BSTR_UserMarshal(  unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, BSTR __RPC_FAR * ); 
unsigned char __RPC_FAR * __RPC_USER  BSTR_UserUnmarshal(unsigned long __RPC_FAR *, unsigned char __RPC_FAR *, BSTR __RPC_FAR * ); 
void                      __RPC_USER  BSTR_UserFree(     unsigned long __RPC_FAR *, BSTR __RPC_FAR * ); 

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif
