/* this ALWAYS GENERATED file contains the definitions for the interfaces */


/* File created by MIDL compiler version 5.01.0164 */
/* at Tue Sep 25 21:52:44 2001
 */
/* Compiler settings for D:\coding\MyProjects\Elflib\ELFLIB.idl:
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

#ifndef __ELFLIB_h__
#define __ELFLIB_h__

#ifdef __cplusplus
extern "C"{
#endif 

/* Forward Declarations */ 

#ifndef __IcStrings_FWD_DEFINED__
#define __IcStrings_FWD_DEFINED__
typedef interface IcStrings IcStrings;
#endif 	/* __IcStrings_FWD_DEFINED__ */


#ifndef __cStrings_FWD_DEFINED__
#define __cStrings_FWD_DEFINED__

#ifdef __cplusplus
typedef class cStrings cStrings;
#else
typedef struct cStrings cStrings;
#endif /* __cplusplus */

#endif 	/* __cStrings_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

void __RPC_FAR * __RPC_USER MIDL_user_allocate(size_t);
void __RPC_USER MIDL_user_free( void __RPC_FAR * ); 

#ifndef __IcStrings_INTERFACE_DEFINED__
#define __IcStrings_INTERFACE_DEFINED__

/* interface IcStrings */
/* [unique][helpstring][dual][uuid][object] */ 


EXTERN_C const IID IID_IcStrings;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    MIDL_INTERFACE("BD9DD02E-CF3C-11D3-B60F-93EEA1CC2573")
    IcStrings : public IDispatch
    {
    public:
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_NumTokens( 
            /* [retval][out] */ long __RPC_FAR *pVal) = 0;
        
        virtual /* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE get_Tokens( 
            long TokenNumber,
            /* [retval][out] */ BSTR __RPC_FAR *pVal) = 0;
        
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE IsOperator( 
            BSTR __RPC_FAR *pVal,
            long pPosition) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IcStringsVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IcStrings __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IcStrings __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IcStrings __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetTypeInfoCount )( 
            IcStrings __RPC_FAR * This,
            /* [out] */ UINT __RPC_FAR *pctinfo);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetTypeInfo )( 
            IcStrings __RPC_FAR * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo __RPC_FAR *__RPC_FAR *ppTInfo);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetIDsOfNames )( 
            IcStrings __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR __RPC_FAR *rgszNames,
            /* [in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID __RPC_FAR *rgDispId);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Invoke )( 
            IcStrings __RPC_FAR * This,
            /* [in] */ DISPID dispIdMember,
            /* [in] */ REFIID riid,
            /* [in] */ LCID lcid,
            /* [in] */ WORD wFlags,
            /* [out][in] */ DISPPARAMS __RPC_FAR *pDispParams,
            /* [out] */ VARIANT __RPC_FAR *pVarResult,
            /* [out] */ EXCEPINFO __RPC_FAR *pExcepInfo,
            /* [out] */ UINT __RPC_FAR *puArgErr);
        
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *get_NumTokens )( 
            IcStrings __RPC_FAR * This,
            /* [retval][out] */ long __RPC_FAR *pVal);
        
        /* [helpstring][id][propget] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *get_Tokens )( 
            IcStrings __RPC_FAR * This,
            long TokenNumber,
            /* [retval][out] */ BSTR __RPC_FAR *pVal);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *IsOperator )( 
            IcStrings __RPC_FAR * This,
            BSTR __RPC_FAR *pVal,
            long pPosition);
        
        END_INTERFACE
    } IcStringsVtbl;

    interface IcStrings
    {
        CONST_VTBL struct IcStringsVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IcStrings_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IcStrings_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IcStrings_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IcStrings_GetTypeInfoCount(This,pctinfo)	\
    (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo)

#define IcStrings_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo)

#define IcStrings_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)

#define IcStrings_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)


#define IcStrings_get_NumTokens(This,pVal)	\
    (This)->lpVtbl -> get_NumTokens(This,pVal)

#define IcStrings_get_Tokens(This,TokenNumber,pVal)	\
    (This)->lpVtbl -> get_Tokens(This,TokenNumber,pVal)

#define IcStrings_IsOperator(This,pVal,pPosition)	\
    (This)->lpVtbl -> IsOperator(This,pVal,pPosition)

#endif /* COBJMACROS */


#endif 	/* C style interface */



/* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE IcStrings_get_NumTokens_Proxy( 
    IcStrings __RPC_FAR * This,
    /* [retval][out] */ long __RPC_FAR *pVal);


void __RPC_STUB IcStrings_get_NumTokens_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id][propget] */ HRESULT STDMETHODCALLTYPE IcStrings_get_Tokens_Proxy( 
    IcStrings __RPC_FAR * This,
    long TokenNumber,
    /* [retval][out] */ BSTR __RPC_FAR *pVal);


void __RPC_STUB IcStrings_get_Tokens_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);


/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE IcStrings_IsOperator_Proxy( 
    IcStrings __RPC_FAR * This,
    BSTR __RPC_FAR *pVal,
    long pPosition);


void __RPC_STUB IcStrings_IsOperator_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IcStrings_INTERFACE_DEFINED__ */



#ifndef __ELFLIBLib_LIBRARY_DEFINED__
#define __ELFLIBLib_LIBRARY_DEFINED__

/* library ELFLIBLib */
/* [helpstring][version][uuid] */ 


EXTERN_C const IID LIBID_ELFLIBLib;

EXTERN_C const CLSID CLSID_cStrings;

#ifdef __cplusplus

class DECLSPEC_UUID("BD9DD02F-CF3C-11D3-B60F-93EEA1CC2573")
cStrings;
#endif
#endif /* __ELFLIBLib_LIBRARY_DEFINED__ */

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
