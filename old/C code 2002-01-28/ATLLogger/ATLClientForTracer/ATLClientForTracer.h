/* this ALWAYS GENERATED file contains the definitions for the interfaces */


/* File created by MIDL compiler version 5.01.0164 */
/* at Mon Jan 03 19:59:40 2000
 */
/* Compiler settings for C:\ArticleNo3\ATLLogApp\ATLClientForTracer\ATLClientForTracer.idl:
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

#ifndef __ATLClientForTracer_h__
#define __ATLClientForTracer_h__

#ifdef __cplusplus
extern "C"{
#endif 

/* Forward Declarations */ 

#ifndef __ICoLoggerClient_FWD_DEFINED__
#define __ICoLoggerClient_FWD_DEFINED__
typedef interface ICoLoggerClient ICoLoggerClient;
#endif 	/* __ICoLoggerClient_FWD_DEFINED__ */


#ifndef __CoLoggerClient_FWD_DEFINED__
#define __CoLoggerClient_FWD_DEFINED__

#ifdef __cplusplus
typedef class CoLoggerClient CoLoggerClient;
#else
typedef struct CoLoggerClient CoLoggerClient;
#endif /* __cplusplus */

#endif 	/* __CoLoggerClient_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

void __RPC_FAR * __RPC_USER MIDL_user_allocate(size_t);
void __RPC_USER MIDL_user_free( void __RPC_FAR * ); 

#ifndef __ICoLoggerClient_INTERFACE_DEFINED__
#define __ICoLoggerClient_INTERFACE_DEFINED__

/* interface ICoLoggerClient */
/* [unique][helpstring][uuid][object] */ 


EXTERN_C const IID IID_ICoLoggerClient;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("D97E8A54-C220-11D3-9739-0050047D51FB")
    ICoLoggerClient : public IUnknown
    {
    public:
        virtual /* [helpstring] */ HRESULT STDMETHODCALLTYPE Initialize( void) = 0;
        
        virtual /* [helpstring] */ HRESULT STDMETHODCALLTYPE UnInitialize( void) = 0;
        
        virtual /* [helpstring] */ HRESULT STDMETHODCALLTYPE Log( 
            /* [in] */ BSTR str) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct ICoLoggerClientVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            ICoLoggerClient __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            ICoLoggerClient __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            ICoLoggerClient __RPC_FAR * This);
        
        /* [helpstring] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Initialize )( 
            ICoLoggerClient __RPC_FAR * This);
        
        /* [helpstring] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *UnInitialize )( 
            ICoLoggerClient __RPC_FAR * This);
        
        /* [helpstring] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Log )( 
            ICoLoggerClient __RPC_FAR * This,
            /* [in] */ BSTR str);
        
        END_INTERFACE
    } ICoLoggerClientVtbl;

    interface ICoLoggerClient
    {
        CONST_VTBL struct ICoLoggerClientVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define ICoLoggerClient_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define ICoLoggerClient_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define ICoLoggerClient_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define ICoLoggerClient_Initialize(This)	\
    (This)->lpVtbl -> Initialize(This)

#define ICoLoggerClient_UnInitialize(This)	\
    (This)->lpVtbl -> UnInitialize(This)

#define ICoLoggerClient_Log(This,str)	\
    (This)->lpVtbl -> Log(This,str)

#endif /* COBJMACROS */


#endif 	/* C style interface */



/* [helpstring] */ HRESULT STDMETHODCALLTYPE ICoLoggerClient_Initialize_Proxy( 
    ICoLoggerClient __RPC_FAR * This);


void __RPC_STUB ICoLoggerClient_Initialize_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring] */ HRESULT STDMETHODCALLTYPE ICoLoggerClient_UnInitialize_Proxy( 
    ICoLoggerClient __RPC_FAR * This);


void __RPC_STUB ICoLoggerClient_UnInitialize_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring] */ HRESULT STDMETHODCALLTYPE ICoLoggerClient_Log_Proxy( 
    ICoLoggerClient __RPC_FAR * This,
    /* [in] */ BSTR str);


void __RPC_STUB ICoLoggerClient_Log_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __ICoLoggerClient_INTERFACE_DEFINED__ */



#ifndef __ATLCLIENTFORTRACERLib_LIBRARY_DEFINED__
#define __ATLCLIENTFORTRACERLib_LIBRARY_DEFINED__

/* library ATLCLIENTFORTRACERLib */
/* [helpstring][version][uuid] */ 


EXTERN_C const IID LIBID_ATLCLIENTFORTRACERLib;

EXTERN_C const CLSID CLSID_CoLoggerClient;

#ifdef __cplusplus

class DECLSPEC_UUID("D97E8A55-C220-11D3-9739-0050047D51FB")
CoLoggerClient;
#endif
#endif /* __ATLCLIENTFORTRACERLib_LIBRARY_DEFINED__ */

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
