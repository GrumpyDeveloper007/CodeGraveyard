// List implementation by Xavier / SCUDD
//
// Node class definition

// uses void * for elements (in other words it keeps a pointer for the data
// rather than a copy of the data)

class ListNode
 {
 public:

 // Constructor

 ListNode (ListNode *Ptr,void *elem=NULL)
  {
  Pointer=Ptr;
  Element=elem;
  }

 // Data members

 void *Element;
 ListNode *Pointer;
 };

// List class definition

class List
 {
 public:

  ListNode *Root;

 // Constructor

 List() // safety precaution nothing more!
  {
  Root=NULL;
  }

 // Destructor

 ~List()
  {
  Clear(Root);			// call clear function
  }

 // Clear

 void Clear(ListNode *Pointer)
  {
  ListNode *CurPtr;		// pointers for current level

  while(Pointer!=NULL)
   {
   CurPtr=Pointer->Pointer;	// Store pointer
   delete Pointer;
   Pointer=CurPtr;
   }
  }

 void Create(void *elem=NULL)
  {
  Root=new ListNode(NULL,elem);
  }

 void Insert(ListNode *Pointer,void *elem=NULL)
  {
  Pointer->Pointer=new ListNode(NULL,elem);
  }
 };