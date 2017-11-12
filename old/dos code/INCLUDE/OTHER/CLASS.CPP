// CLASS routines V1.0
//
// class LIST - Linked list uses void * as the element!

#include <mem.h>

#include "h\class.h"

ListNode::ListNode(void *elem,ListNode *nextPtr)
 {
 element=elem;
 next=nextPtr;
 }

List::List(int ignored)
 {
 head=NULL;
 cursor=NULL;
 }

void List::insertBefore(void *newElement)
 {
 ListNode *temp;

 if (!full())
  {
  if (!empty())
   {
   temp=cursor;
   cursor=new ListNode(cursor->element,cursor->next);
   temp->next=cursor;
   temp->element=newElement;
   cursor=temp;
   }
  else
   {
   cursor=new ListNode(newElement,NULL);
   head=cursor;
   }
  }
 }

void List::moveToBeginning()
 {
 void *element;
 if (!empty())
  {
  element=getCursor();	// get element at cursor position
  remove();		// remove element from list
  cursor=new ListNode(element,head);
  head=cursor;
  }
 }

List::~List()
 {
 clear();
 }

void List::insert(void *newElement)
 {
 ListNode *temp;

 if (!empty())
  {
  temp=cursor;
  cursor=new ListNode(newElement,cursor->next);
  temp->next=cursor;
  }
 else
  {
  cursor=new ListNode(newElement,NULL);
  head=cursor;
  }
 }

void List::remove()
 {
 ListNode *temp;

 if (!empty())
  {
  if (cursor!=head)	// not at beginning of list
   {
   temp=head;
   while(temp->next!=cursor)
    temp=temp->next;		// Move through list to node before cursor
   temp->next=cursor->next;	// set to skip current cursor element
   temp=cursor;
   cursor=cursor->next;	// move cursor to new element
   delete temp;
   if (cursor==NULL)
    cursor=head;
   }
  else
   {
   temp=head;
   head=head->next;
   cursor=head;
   delete temp;
   }
  }
 }

void List::replace(void *newElement)
 {
 cursor->element=newElement;
 }

void List::clear()
 {
 ListNode *temp;

 while (head!=NULL)
  {
  temp=head;
  head=head->next;
  delete temp;
  }
 cursor=NULL;
 }

int List::empty() const
 {
 if (head==NULL)
  return (1==1);
 return (1==0);
 }

int List::full() const
 {
 return (1==0);
 }

int List::gotoBeginning()
 {
 if (!empty())
  {
  cursor=head;
  return (1==1);
  }
 return (1==0);
 }

int List::gotoEnd()
 {
 if (!empty())
  {
  cursor=head;
  while(cursor->next!=NULL)	// while not last element
   cursor=cursor->next;
  return (1==1);
  }
 return (1==0);
 }

int List::gotoNext()
 {
 if (!empty())
  {
  if (cursor->next!=NULL)
   {
   cursor=cursor->next;
   return (1==1);
   }
  }
 return (1==0);
 }

int List::gotoPrior()
 {
 ListNode *temp;

 if (!empty())
  {
  if (cursor!=head)
   {
   temp=head;
   while (temp->next!=cursor)    // scan for element before cursor
    temp=temp->next;
   cursor=temp;
   return (1==1);
   }
  }
 return (1==0);
 }

void *List::getCursor() const
 {
 if (!empty())
  return cursor->element;
 return 0;
 }

int List::count()
 {
 int Count=1;

 if (empty())
  return 0;

 gotoBeginning();

 while(gotoNext())
  Count++;

 return Count;
 }
