// Span List implementation by Xavier / SCUDD
//
// Node class definition

class ListNode
 {
 public:

 // Constructor

 ListNode (short SpanLeft,short SpanRight,ListNode *Ptr,void *Pgon=NULL)
  {
  Pointer=Ptr;
  Left=SpanLeft;
  Right=SpanRight;
  Polygon=Pgon;
  }

 // Data members

 short Left,Right;
 void *Polygon;
 ListNode *Pointer;
 };

// List class definition

class List
 {
 public:

  ListNode *Root;

 // Constructor

 List()
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

 void Create(short Left,short Right,void *Pgon=NULL)
  {
  Root=new ListNode(Left,Right,NULL,Pgon);
  }

 void Insert(short Left,short Right,ListNode *Pointer,void *Pgon=NULL)
  {
  Pointer->Pointer=new ListNode(Left,Right,NULL,Pgon);
  }
 };