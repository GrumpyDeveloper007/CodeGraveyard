///////////////////////////////////
//
// Memory operations

// InitMemory(Address,Size) -- Inits memory
// CleanMem() -- De-fregments the memory list (HOPEFULLY)
// Old((unsigned char*)Location,Size) -- De-allocates memory returns 1 if fail
// New(Size) -- Allocates memory (returns unsigned char *)

// Notes: Old may fail if memory becomes too fragmented, the limit of
// fragmentation is defined by a constant varible.

// Alloc scans a linked list containing all unallocated memory units, when
// it finds one of required size it either removes the list entry if size is
// equal to the size required or changes the entry, removing the allocated
// chunk. Therefore the allocation of memory is relatively fast if not too
// fraged.

// If it is knowned that memory will be in allmost all de-allocate state. It
// may be more efficient to optimize the list before allocating memory.

///////////////////////////////////

struct MemoryUnit
 {
 unsigned char *Start; // Start
 int Size;   // End of memory block (if =0 then empty entry)
 MemoryUnit *Next;  // Next block in list
 };
const MaxBlocks=1000;
unsigned char *MemoryBlock;
MemoryUnit AllocList[MaxBlocks];
MemoryUnit *AllocStart=0; 

// Locate memory that can be attached to current address
MemoryUnit* FindFriend(unsigned char *Address,int Start)
 {
 void *Temp=AllocList[Start].Start;

 MemoryUnit *Current=(MemoryUnit*)Temp;
 while (Current->Size!=0)
  {
  if (Current->Start==Address)
    return Current;
  if (Current->Start+Current->Size==Address)
    return Current;
  Current=Current->Next;
  }
 return 0;
 }

// This may not compress the memory list to one entry, has to be tested
void CleanMem()
 {
 MemoryUnit *Current=AllocStart,*Target=AllocStart,*PreTarget;
 unsigned char *CAddress1,*CAddress2;
 
 while(Current->Next!=0)
  {
  CAddress1=Current->Start;
  CAddress2=Current->Start+Current->Size;

  PreTarget=Current;
  Target=Current->Next;
  // Read ahead

  if ( (Target->Start+Target->Size)==CAddress1)
   { // Attach target to begining
   Current->Size+=Target->Size;
   Current->Start=Target->Start;

   PreTarget->Next=Target->Next; // Keep list tidy

   CAddress1=Target->Start; // Update search data
   Target->Size=0; // Delete entry
   }
  if ( Target->Start==CAddress2 )
   { // Attach target to end
   Current->Size+=Target->Size;

   PreTarget->Next=Target->Next; // Keep list tidy

   CAddress2+=Target->Size; // update search data
   Target->Size=0; // Delete entry
   }

  while (Target->Next!=0) // Not end of linked list
   {
    if ( (Target->Start+Target->Size)==CAddress1)
     { // Attach target to begining
     Current->Size+=Target->Size;
     Current->Start=Target->Start;

     PreTarget->Next=Target->Next; // Keep list tidy

     CAddress1=Target->Start; // Update search data
     Target->Size=0; // Delete entry
     }
    if ( Target->Start==CAddress2 )
     { // Attach target to end
     Current->Size+=Target->Size;

     PreTarget->Next=Target->Next; // Keep list tidy

     CAddress2+=Target->Size; // update search data
     Target->Size=0; // Delete entry
    }
   }

  if (Current->Next!=0) // Make sure list hasent shunk too much
    Current=Current->Next;
  }
 }

void InitMemory(unsigned char *Address,int Size)
 {
 int i;
 for (i=0;i<MaxBlocks;i++)
  {
  AllocList[i].Start=0;
  }
 AllocList[0].Start=Address; 
 AllocList[0].Size=Size; 
 AllocList[0].Next=0; 
 AllocStart=AllocList;
 }

// Return memory chunk
int Old(void *LocationP,int Size)
 {
 unsigned char *Location=(unsigned char*)LocationP;
 int Fin=0;
 int i;
 unsigned char *End=Location+Size;
 MemoryUnit *Current=AllocStart;

 // Read ahead
 // Attach to begining
 if (End==Current->Start)  
  {
  Current->Start=Location;
  Current->Size+=Size;
  Fin=1;
  }
 // Attach to end
 if ( (Current->Start+Current->Size==Location) )
  {
  Current->Size+=Size;
  Fin=1;
  }

 while (Current->Next!=0 && Fin==0)
  {
  // IF memory blocks can be attached to another block then attach
  // ELSE create new list entry

  // Attach to begining
  if (End==Current->Start)  
   {
   Current->Start=Location;
   Current->Size+=Size;
   Fin=1;
   }

  // Attach to end
  if ( (Current->Start+Current->Size==Location) )
   {
   Current->Size+=Size;
   Fin=1;
   }
  }
 // ELSE (Fin==0) then make new list entry
 if (Fin==0)
  {
  Fin=0;
  for (i=0;i<MaxBlocks;i++)
   {
   if (AllocList[i].Size==0)
    {
    AllocList[i].Start=Location;
    AllocList[i].Size=Size;
    AllocList[i].Next=0;
    Current->Next=(MemoryUnit *) AllocList[i].Start; // i hope this works
    }
   }
  }
 return Fin;
 }

// Get memory
void* New(int Size)
 {
 MemoryUnit *Current=AllocStart,*Previos;
 unsigned char *Mem=0;

 // Do special case (read ahead)
 if (Current->Size>Size)
  {
  Mem=Current->Start;   // Return address of chunk
  if (Current->Size==Size)
    {
    Previos->Next=0;  // remove element
    Current->Size=0;///////////////////////////////////////////////maybe
    }
  else
    {
    Current->Size-=Size;
    Current->Start+=Size;
    }
  }
  Previos=Current;
  Current=Current->Next;
 if (Current!=0)
   while (Current->Next!=0 && Mem==0)
    {
    // IF block is bigger then change list entry to space left
    // ELSE remove entry
    if (Current->Size>Size)
     {
     Mem=Current->Start;   // Return address of chunk
     if (Current->Size==Size)
       {
       Previos->Next=Current->Next;  // remove element
       Current->Size=0;
       Current->Start=0;  /////////////////////////////////////////maybe
       }
     else
       {
       Current->Size-=Size;
       Current->Start+=Size; // Update start location
       }
     }
    Previos=Current;       // Store previos
    Current=Current->Next;  // Link.Next
    }
 return Mem;
 }
