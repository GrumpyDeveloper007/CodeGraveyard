/* this ALWAYS GENERATED file contains the definitions for the interfaces */


/* File created by MIDL compiler version 5.01.0164 */
/* at Thu Jan 27 21:34:40 2000
 */
/* Compiler settings for D:\coding\MyProjects\beeper\beeper.idl:
    Os (OptLev=s), W1, Zp8, env=Win32, ms_ext, c_ext
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

#ifndef __beeper_h__
#define __beeper_h__

#ifdef __cplusplus
extern "C"{
#endif 

/* Forward Declarations */ 

#ifndef __IBeeper_FWD_DEFINED__
#define __IBeeper_FWD_DEFINED__
typedef interface IBeeper IBeeper;
#endif 	/* __IBeeper_FWD_DEFINED__ */


#ifndef __Beeper_FWD_DEFINED__
#define __Beeper_FWD_DEFINED__

#ifdef __cplusplus
typedef class Beeper Beeper;
#else
typedef struct Beeper Beeper;
#endif /* __cplusplus */

#endif 	/* __Beeper_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"

void __RPC_FAR * __RPC_USER MIDL_user_allocate(size_t);
void __RPC_USER MIDL_user_free( void __RPC_FAR * ); 

#ifndef __IBeeper_INTERFACE_DEFINED__
#define __IBeeper_INTERFACE_DEFINED__

/* interface IBeeper */
/* [unique][helpstring][dual][uuid][object] */ 


EXTERN_C const IID IID_IBeeper;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("6384D584-0FDB-11cf-8700-00AA0053006D")
    IBeeper : public IDispatch
    {
    public:
        virtual /* [helpstring] */ HRESULT STDMETHODCALLTYPE Beep( void) = 0;
        
        virtual /* [helpstring][propget] */ HRESULT STDMETHODCALLTYPE get_Count( 
            /* [retval][out] */ long __RPC_FAR *retval) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Item( 
            /* [in] */ long Index,
            /* [retval][out] */ BSTR __RPC_FAR *pbstr) = 0;
        
        virtual /* [id][restricted][propget] */ HRESULT STDMETHODCALLTYPE get__NewEnum( 
            /* [retval][out] */ IUnknown __RPC_FAR *__RPC_FAR *retval) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IBeeperVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IBeeper __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IBeeper __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IBeeper __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetTypeInfoCount )( 
            IBeeper __RPC_FAR * This,
            /* [out] */ UINT __RPC_FAR *pctinfo);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetTypeInfo )( 
            IBeeper __RPC_FAR * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo __RPC_FAR *__RPC_FAR *ppTInfo);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetIDsOfNames )( 
            IBeeper __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR __RPC_FAR *rgszNames,
            /* [in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID __RPC_FAR *rgDispId);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Invoke )( 
            IBeeper __RPC_FAR * This,
            /* [in] */ DISPID dispIdMember,
            /* [in] */ REFIID riid,
            /* [in] */ LCID lcid,
            /* [in] */ WORD wFlags,
            /* [out][in] */ DISPPARAMS __RPC_FAR *pDispParams,
            /* [out] */ VARIANT __RPC_FAR *pVarResult,
            /* [out] */ EXCEPINFO __RPC_FAR *pExcepInfo,
            /* [out] */ UINT __RPC_FAR *puArgErr);
        
        /* [helpstring] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Beep )( 
            IBeeper __RPC_FAR * This);
        
        /* [helpstring][propget] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *get_Count )( 
            IBeeper __RPC_FAR * This,
            /* [retval][out] */ long __RPC_FAR *retval);
        
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *get_Item )( 
            IBeeper __RPC_FAR * This,
            /* [in] */ long Index,
            /* [retval][out] */ BSTR __RPC_FAR *pbstr);
        
        /* [id][restricted][propget] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *get__NewEnum )( 
            IBeeper __RPC_FAR * This,
            /* [retval][out] */ IUnknown __RPC_FAR *__RPC_FAR *retval);
        
        END_INTERFACE
    } IBeeperVtbl;

    interface IBeeper
    {
        CONST_VTBL struct IBeeperVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IBeeper_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IBeeper_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IBeeper_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IBeeper_GetTypeInfoCount(This,pctinfo)	\
    (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo)

#define IBeeper_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo)

#define IBeeper_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)

#define IBeeper_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)


#define IBeeper_Beep(This)	\
    (This)->lpVtbl -> Beep(This)

#define IBeeper_get_Count(This,retval)	\
    (This)->lpVtbl -> get_Count(This,retval)

#define IBeeper_get_Item(This,Index,pbstr)	\
    (This)->lpVtbl -> get_Item(This,Index,pbstr)

#define IBeeper_get__NewEnum(This,retval)	\
    (This)->lpVtbl -> get__NewEnum(This,retval)

#endif /* COBJMACROS */


#endif 	/* C style interface */



/* [helpstring] */ HRESULT STDMETHODCALLTYPE IBeeper_Beep_Proxy( 
    IBeeper __RPC_FAR * This);


void __RPC_STUB IBeeper_Beep_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][propget] */ HRESULT STDMETHODCALLTYPE IBeeper_get_Count_Proxy( 
    IBeeper __RPC_FAR * This,
    /* [retval][out] */ long __RPC_FAR *retval);


void __RPC_STUB IBeeper_get_Count_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE IBeeper_get_Item_Proxy( 
    IBeeper __RPC_FAR * This,
    /* [in] */ long Index,
    /* [retval][out] */ BSTR __RPC_FAR *pbstr);


void __RPC_STUB IBeeper_get_Item_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [id][restricted][propget] */ HRESULT STDMETHODCALLTYPE IBeeper_get__NewEnum_Proxy( 
    IBeeper __RPC_FAR * This,
    /* [retval][out] */ IUnknown __RPC_FAR *__RPC_FAR *retval);


void __RPC_STUB IBeeper_get__NewEnum_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IBeeper_INTERFACE_DEFINED__ */



#ifndef __BeeperLib_LIBRARY_DEFINED__
#define __BeeperLib_LIBRARY_DEFINED__

/* library BeeperLib */
/* [version][helpstring][uuid] */ 


EXTERN_C const IID LIBID_BeeperLib;

EXTERN_C const CLSID CLSID_Beeper;

#ifdef __cplusplus

class DECLSPEC_UUID("6384D586-0FDB-11cf-8700-00AA0053006D")
Beeper;
#endif
#endif /* __BeeperLib_LIBRARY_DEFINED__ */

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
