/* this ALWAYS GENERATED file contains the definitions for the interfaces */


/* File created by MIDL compiler version 3.01.75 */
/* at Thu Sep 11 10:43:48 1997
 */
/* Compiler settings for VBTest.idl:
    Oicf (OptLev=i2), W1, Zp8, env=Win32, ms_ext, c_ext
    error checks: none
*/
//@@MIDL_FILE_HEADING(  )
#include "rpc.h"
#include "rpcndr.h"
#ifndef COM_NO_WINDOWS_H
#include "windows.h"
#include "ole2.h"
#endif /*COM_NO_WINDOWS_H*/

#ifndef __VBTest_h__
#define __VBTest_h__

#ifdef __cplusplus
extern "C"{
#endif 

/* Forward Declarations */ 

#ifndef __IBase_FWD_DEFINED__
#define __IBase_FWD_DEFINED__
typedef interface IBase IBase;
#endif 	/* __IBase_FWD_DEFINED__ */


#ifndef __IDerived_FWD_DEFINED__
#define __IDerived_FWD_DEFINED__
typedef interface IDerived IDerived;
#endif 	/* __IDerived_FWD_DEFINED__ */


#ifndef __VBTest1_FWD_DEFINED__
#define __VBTest1_FWD_DEFINED__

#ifdef __cplusplus
typedef class VBTest1 VBTest1;
#else
typedef struct VBTest1 VBTest1;
#endif /* __cplusplus */

#endif 	/* __VBTest1_FWD_DEFINED__ */


#ifndef __VBTest2_FWD_DEFINED__
#define __VBTest2_FWD_DEFINED__

#ifdef __cplusplus
typedef class VBTest2 VBTest2;
#else
typedef struct VBTest2 VBTest2;
#endif /* __cplusplus */

#endif 	/* __VBTest2_FWD_DEFINED__ */


/* header files for imported files */
#include "oaidl.h"
#include "ocidl.h"

void __RPC_FAR * __RPC_USER MIDL_user_allocate(size_t);
void __RPC_USER MIDL_user_free( void __RPC_FAR * ); 

#ifndef __IBase_INTERFACE_DEFINED__
#define __IBase_INTERFACE_DEFINED__

/****************************************
 * Generated header for interface: IBase
 * at Thu Sep 11 10:43:48 1997
 * using MIDL 3.01.75
 ****************************************/
/* [unique][helpstring][dual][uuid][object] */ 



EXTERN_C const IID IID_IBase;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    interface DECLSPEC_UUID("2F6E4231-2A8F-11D1-A988-002018349816")
    IBase : public IDispatch
    {
    public:
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE MethodBase( void) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IBaseVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IBase __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IBase __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IBase __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetTypeInfoCount )( 
            IBase __RPC_FAR * This,
            /* [out] */ UINT __RPC_FAR *pctinfo);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetTypeInfo )( 
            IBase __RPC_FAR * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo __RPC_FAR *__RPC_FAR *ppTInfo);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetIDsOfNames )( 
            IBase __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR __RPC_FAR *rgszNames,
            /* [in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID __RPC_FAR *rgDispId);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Invoke )( 
            IBase __RPC_FAR * This,
            /* [in] */ DISPID dispIdMember,
            /* [in] */ REFIID riid,
            /* [in] */ LCID lcid,
            /* [in] */ WORD wFlags,
            /* [out][in] */ DISPPARAMS __RPC_FAR *pDispParams,
            /* [out] */ VARIANT __RPC_FAR *pVarResult,
            /* [out] */ EXCEPINFO __RPC_FAR *pExcepInfo,
            /* [out] */ UINT __RPC_FAR *puArgErr);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *MethodBase )( 
            IBase __RPC_FAR * This);
        
        END_INTERFACE
    } IBaseVtbl;

    interface IBase
    {
        CONST_VTBL struct IBaseVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IBase_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IBase_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IBase_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IBase_GetTypeInfoCount(This,pctinfo)	\
    (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo)

#define IBase_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo)

#define IBase_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)

#define IBase_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)


#define IBase_MethodBase(This)	\
    (This)->lpVtbl -> MethodBase(This)

#endif /* COBJMACROS */


#endif 	/* C style interface */



/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE IBase_MethodBase_Proxy( 
    IBase __RPC_FAR * This);


void __RPC_STUB IBase_MethodBase_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IBase_INTERFACE_DEFINED__ */


#ifndef __IDerived_INTERFACE_DEFINED__
#define __IDerived_INTERFACE_DEFINED__

/****************************************
 * Generated header for interface: IDerived
 * at Thu Sep 11 10:43:48 1997
 * using MIDL 3.01.75
 ****************************************/
/* [unique][helpstring][dual][uuid][object] */ 



EXTERN_C const IID IID_IDerived;

#if defined(__cplusplus) && !defined(CINTERFACE)
    
    interface DECLSPEC_UUID("2F6E422E-2A8F-11D1-A988-002018349816")
    IDerived : public IBase
    {
    public:
        virtual /* [helpstring][id] */ HRESULT STDMETHODCALLTYPE MethodDerived( void) = 0;
        
    };
    
#else 	/* C style interface */

    typedef struct IDerivedVtbl
    {
        BEGIN_INTERFACE
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *QueryInterface )( 
            IDerived __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [iid_is][out] */ void __RPC_FAR *__RPC_FAR *ppvObject);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *AddRef )( 
            IDerived __RPC_FAR * This);
        
        ULONG ( STDMETHODCALLTYPE __RPC_FAR *Release )( 
            IDerived __RPC_FAR * This);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetTypeInfoCount )( 
            IDerived __RPC_FAR * This,
            /* [out] */ UINT __RPC_FAR *pctinfo);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetTypeInfo )( 
            IDerived __RPC_FAR * This,
            /* [in] */ UINT iTInfo,
            /* [in] */ LCID lcid,
            /* [out] */ ITypeInfo __RPC_FAR *__RPC_FAR *ppTInfo);
        
        HRESULT ( STDMETHODCALLTYPE __RPC_FAR *GetIDsOfNames )( 
            IDerived __RPC_FAR * This,
            /* [in] */ REFIID riid,
            /* [size_is][in] */ LPOLESTR __RPC_FAR *rgszNames,
            /* [in] */ UINT cNames,
            /* [in] */ LCID lcid,
            /* [size_is][out] */ DISPID __RPC_FAR *rgDispId);
        
        /* [local] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *Invoke )( 
            IDerived __RPC_FAR * This,
            /* [in] */ DISPID dispIdMember,
            /* [in] */ REFIID riid,
            /* [in] */ LCID lcid,
            /* [in] */ WORD wFlags,
            /* [out][in] */ DISPPARAMS __RPC_FAR *pDispParams,
            /* [out] */ VARIANT __RPC_FAR *pVarResult,
            /* [out] */ EXCEPINFO __RPC_FAR *pExcepInfo,
            /* [out] */ UINT __RPC_FAR *puArgErr);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *MethodBase )( 
            IDerived __RPC_FAR * This);
        
        /* [helpstring][id] */ HRESULT ( STDMETHODCALLTYPE __RPC_FAR *MethodDerived )( 
            IDerived __RPC_FAR * This);
        
        END_INTERFACE
    } IDerivedVtbl;

    interface IDerived
    {
        CONST_VTBL struct IDerivedVtbl __RPC_FAR *lpVtbl;
    };

    

#ifdef COBJMACROS


#define IDerived_QueryInterface(This,riid,ppvObject)	\
    (This)->lpVtbl -> QueryInterface(This,riid,ppvObject)

#define IDerived_AddRef(This)	\
    (This)->lpVtbl -> AddRef(This)

#define IDerived_Release(This)	\
    (This)->lpVtbl -> Release(This)


#define IDerived_GetTypeInfoCount(This,pctinfo)	\
    (This)->lpVtbl -> GetTypeInfoCount(This,pctinfo)

#define IDerived_GetTypeInfo(This,iTInfo,lcid,ppTInfo)	\
    (This)->lpVtbl -> GetTypeInfo(This,iTInfo,lcid,ppTInfo)

#define IDerived_GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)	\
    (This)->lpVtbl -> GetIDsOfNames(This,riid,rgszNames,cNames,lcid,rgDispId)

#define IDerived_Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)	\
    (This)->lpVtbl -> Invoke(This,dispIdMember,riid,lcid,wFlags,pDispParams,pVarResult,pExcepInfo,puArgErr)


#define IDerived_MethodBase(This)	\
    (This)->lpVtbl -> MethodBase(This)


#define IDerived_MethodDerived(This)	\
    (This)->lpVtbl -> MethodDerived(This)

#endif /* COBJMACROS */


#endif 	/* C style interface */



/* [helpstring][id] */ HRESULT STDMETHODCALLTYPE IDerived_MethodDerived_Proxy( 
    IDerived __RPC_FAR * This);


void __RPC_STUB IDerived_MethodDerived_Stub(
    IRpcStubBuffer *This,
    IRpcChannelBuffer *_pRpcChannelBuffer,
    PRPC_MESSAGE _pRpcMessage,
    DWORD *_pdwStubPhase);



#endif 	/* __IDerived_INTERFACE_DEFINED__ */



#ifndef __VBTESTLib_LIBRARY_DEFINED__
#define __VBTESTLib_LIBRARY_DEFINED__

/****************************************
 * Generated header for library: VBTESTLib
 * at Thu Sep 11 10:43:48 1997
 * using MIDL 3.01.75
 ****************************************/
/* [helpstring][version][uuid] */ 



EXTERN_C const IID LIBID_VBTESTLib;

#ifdef __cplusplus
EXTERN_C const CLSID CLSID_VBTest1;

class DECLSPEC_UUID("2F6E4232-2A8F-11D1-A988-002018349816")
VBTest1;
#endif

#ifdef __cplusplus
EXTERN_C const CLSID CLSID_VBTest2;

class DECLSPEC_UUID("2F6E422F-2A8F-11D1-A988-002018349816")
VBTest2;
#endif
#endif /* __VBTESTLib_LIBRARY_DEFINED__ */

/* Additional Prototypes for ALL interfaces */

/* end of Additional Prototypes */

#ifdef __cplusplus
}
#endif

#endif
