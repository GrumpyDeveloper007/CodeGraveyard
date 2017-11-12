// Binary Tree implementation by Xavier / SCUDD
//
// Node class definition

// uses void * for elements (in other words it keeps a pointer for the data
// rather than a copy of the data)

class TreeNode
 {
 public:

 // Constructor

 TreeNode (void *elem,TreeNode *LeftPtr,TreeNode *RightPtr)
  {
  Left=LeftPtr;
  Right=RightPtr;
  Element=elem;
  }

 // Data members

 void *Element;
 TreeNode *Left,
	  *Right;
 };

// Tree class definition

class Tree
 {
 public:

  TreeNode *Root;

 // Constructor

 Tree(void *elem=NULL)
  {
  Create(elem);
  }

 // Destructor

 ~Tree()
  {
  Clear(Root);			// call clear function
  }

 // Clear

 void Clear(TreeNode *Pointer)
  {
  TreeNode *CurLeftPtr,		// pointers for current level
	   *CurRightPtr;

  while(Pointer!=NULL)
   {
   CurLeftPtr=Pointer->Left;	// Store left pointer
   CurRightPtr=Pointer->Right;	// Store right pointer
   if(CurLeftPtr!=NULL)
    Clear(CurLeftPtr);		// go down the left branch
   if(CurRightPtr!=NULL)
    Clear(CurRightPtr);		// go down the right branch
   delete Pointer;
   Pointer=0;
   }
  }

 void Create(void *element)
  {
  Root=new TreeNode(element,NULL,NULL);
  }

 void InsertLeft(void *element,TreeNode *Pointer)
  {
  Pointer->Left=new TreeNode(element,NULL,NULL);
  }

 void InsertRight(void *element,TreeNode *Pointer)
  {
  Pointer->Right=new TreeNode(element,NULL,NULL);
  }

 };