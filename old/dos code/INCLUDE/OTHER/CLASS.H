
// LIST 

class ListNode                 // Facilitator class for the List class
{
  private:

    // Constructor
    ListNode (void *elem, ListNode *nextPtr );

    // Data members
    void *element;       // List element
    ListNode *next;   // Pointer to the next element

  friend class List;
};

class List
{
  public:

    // Constructor
    List ( int ignored = 0 );

    // Destructor
    ~List ();

    // List manipulation operations
    void insert ( void *newElement );    // Insert after cursor
    void remove ();                          // Remove element
    void replace ( void *newElement );   // Replace element
    void clear ();                           // Clear list

    // List status operations
    int empty () const;                      // List is empty
    int full () const;                       // List is full

    // List iteration operations
    int gotoBeginning ();                    // Go to beginning
    int gotoEnd ();                          // Go to end
    int gotoNext ();                         // Go to next element
    int gotoPrior ();                        // Go to prior element
    void *getCursor () const;                   // Return element

    // In-lab operations
    void moveToBeginning ();                 // Move to beginning
    void insertBefore (void *newElement );
                                             // Insert before cursor

    int count();        // how many elements in list

  private:

    // Data members
    ListNode *head,     // Pointer to the beginning of the list
             *cursor;   // Cursor pointer
};
