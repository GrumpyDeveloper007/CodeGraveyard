{$M 49152, 0, 655360}
program SNES_Cross_Assembler;

const
  max_labels=8192;
  label_name_size=18;
  mne_count=109;
  mne_word: array [0..mne_count-1] of string [3]=(
    'BRK','CLC','CLD','CLI','CLV','DEX','DEY','INX',
    'INY','NOP','PHA','PHB','PHD','PHK','PHP','PHX',
    'PHY','PLA','PLB','PLD','PLP','PLX','PLY','RTI',
    'RTL','RTS','SEC','SED','SEI','STP','SWA','TAD',
    'TAS','TAX','TAY','TCD','TCS','TDA','TDC','TSA',
    'TSC','TSX','TXA','TXS','TXY','TYA','TYX','WAI',
    'XBA','XCE','ADC','AND','CMP','EOR','LDA','ORA',
    'SBC','STA','STX','STY','ASL','LSR','ROL','ROR',
    'DEC','INC','CPX','CPY','LDX','LDY','JMP','JML',
    'JSR','JSL','BIT','BCC','BCS','BEQ','BMI','BNE',
    'BPL','BRA','BVC','BVS','BRL','MVN','MVP','PEA',
    'PEI','PER','REP','SEP','STZ','TRB','TSB','ORG',
    'INT','BIN','PAD','EQU','DCB','DCW','DSB','DSW',
    'DB','DW','NAM','COU','VER');
  mne_type: array [0..mne_count-1] of byte=(
    $00,$00,$00,$00,$00,$00,$00,$00,
    $00,$00,$00,$00,$00,$00,$00,$00,
    $00,$00,$00,$00,$00,$00,$00,$00,
    $00,$00,$00,$00,$00,$00,$00,$00,
    $00,$00,$00,$00,$00,$00,$00,$00,
    $00,$00,$00,$00,$00,$00,$00,$00,
    $00,$00,$01,$01,$01,$01,$01,$01,
    $01,$01,$02,$02,$03,$03,$03,$03,
    $04,$04,$05,$05,$06,$06,$07,$08,
    $09,$0A,$0B,$0C,$0C,$0C,$0C,$0C,
    $0C,$0C,$0C,$0C,$0D,$0E,$0E,$0F,
    $10,$11,$11,$11,$12,$13,$13,$FF,
    $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,
    $FF,$FF,$FF,$FF,$FF);
  mne_opcode: array [0..mne_count-1] of byte=(
    $00,$18,$D8,$58,$B8,$CA,$88,$E8,
    $C8,$EA,$48,$8B,$0B,$4B,$08,$DA,
    $5A,$68,$AB,$2B,$28,$FA,$7A,$40,
    $6B,$60,$38,$F8,$78,$DB,$EB,$5B,
    $1B,$AA,$A8,$5B,$1B,$7B,$7B,$3B,
    $3B,$BA,$8A,$9A,$9B,$98,$BB,$CB,
    $EB,$FB,$61,$21,$C1,$41,$A1,$01,
    $E1,$81,$86,$84,$06,$46,$26,$66,
    $C6,$E6,$E0,$C0,$A2,$A0,$4C,$DC,
    $20,$22,$24,$90,$B0,$F0,$30,$D0,
    $10,$80,$50,$70,$82,$54,$44,$F4,
    $D4,$62,$C2,$E2,$64,$14,$04,$00,
    $00,$00,$00,$00,$00,$00,$00,$00,
    $00,$00,$00,$00,$00);

type
  label_rec = record
    name: string [label_name_size];
    address: longint;
    pass: byte;
  end;

var
  src_name: string;
  src_file: text;
  obj_name: string;
  obj_file: file;
  smc_name: string;
  smc_file: file;
  err_name: string;
  err_file: text;
  lst_name: string;
  lst_file: text;
  lab_name: string;
  lab_file: text;

  label_index: longint;
  label_list: array [0..max_labels] of ^label_rec;
  label_: label_rec;
  last_label: longint;

  no_byte: byte;
  no_long: byte;
  no_word: byte;
  err_flag: byte;
  write_op: byte;

  pass: byte;
  name: string;
  country: byte;
  version: byte;
  line_index: longint;
  start_address: longint;
  address_index: longint;
  error_index: longint;
  opcode_list: string;
  opcode_count: longint;
  f1, f2, f3, f4: string;
  _label, operator, operand, comment: string;

  show_listings: byte;
  save_lab: byte;
  save_lst: byte;
  show_lines: byte;

function upper (s: string): string;
var b: byte;
begin
  for b:=1 to length (s) do
    s [b]:=upcase (s [b]);
  upper:=s;
end;

function inttostr (l: longint): string;
var s: string;
begin
  str (l, s);
  inttostr:=s;
end;

function dectohex (l: longint; w: byte): string;
const hextable: string=('0123456789ABCDEF');
var s: string;
    b: byte;
begin
  s:='';
  for b:=(w-1) downto 0 do
    s:=s+hextable [1+(l shr (b*4)) and 15];
  dectohex:=s;
end;

function hextodec (s: string): longint;
const hextable='0123456789ABCDEF';
var l, m: longint;
    b: byte;
begin
  l:=0;
  m:=1;
  for b:=length (s) downto 1 do
  begin
    l:=l+(pos (upper (s [b]), hextable)-1)*m;
    m:=m*16;
  end;
  hextodec:=l;
end;

function bintodec (s: string): longint;
const bintable='01';
var l,m: longint;
    b: byte;
begin
  l:=0;
  m:=1;
  for b:=length (s) downto 1 do
  begin
    l:=l+(pos (s [b], bintable)-1)*m;
    m:=m*2;
  end;
  bintodec:=l;
end;

procedure kill_leadspace (var s: string);
var b: byte;
begin
  b:=1;
  while (s [b]=' ') do inc (b);
  delete (s, 1, b-1);
end;

procedure kill_followspace (var s: string);
var b: byte;
begin
  b:=length (s);
  while (s [b]=' ') do dec (b);
  delete (s, b+1, length (s)-b);
end;

function adj_left (s: string; l: byte; c: char): string;
begin
  while (length (s) < l) do
    s:=s+c;
  adj_left:=s;
end;

function adj_right (s: string; l: byte; c: char): string;
begin
  while (length (s) < l) do
    s:=c+s;
  adj_right:=s;
end;

procedure show_error (e: string);
begin
  writeln ('ERROR in line ', line_index,': ', e);
  writeln (err_file, 'ERROR in line ', line_index,': ', e);
  inc (error_index);
end;

procedure get_label_mem;
var w: word;
    l: label_rec;
begin
  l.name:='';
  l.address:=0;
  l.pass:=0;
  for w:=0 to max_labels do
  begin
    getmem (label_list [w], sizeof (label_rec));
    label_list [w]^:=l;
  end;
  label_index:=0;
end;

procedure free_label_mem;
var w: word;
begin
  for w:=0 to max_labels do
    freemem (label_list [w], sizeof (label_rec));
  label_index:=0;
end;

procedure save_label (name: string; address: longint; pass: byte; w: word);
var l: label_rec;
begin
  l.name:=name;
  l.address:=address;
  l.pass:=pass;
  label_list [w]^:=l;
end;

procedure save_new_label (name: string; address: longint; pass: byte);
var l: label_rec;
begin
  save_label (name, address, pass, label_index);
  inc (label_index);
end;

function find_label (s: string): word;
var w: word;
    l: label_rec;
begin
  s:=upper (copy (s, 1, label_name_size));
  w:=0;
  repeat
    l:=label_list [w]^;
    inc (w);
  until (w >= label_index) or (l.name = s);
  if (l.name = s) then
  begin
    dec (w);
    find_label:=w;
  end else find_label:=$ffff;
end;

procedure parse_line (l: string; var f1, f2, f3, f4: string);
var b: byte;
    s, t: string;
    quote: byte;
begin
  f1:='';
  f2:='';
  f3:='';
  f4:='';
  s:=l;
  while (pos (#9, s) > 0) do
  begin
    b:=pos (#9, s);
    delete (s, b, 1);
    insert ('        ', s, b);
  end;

  kill_leadspace (s);
  kill_followspace (s);

  t:='';
  b:=1;
  quote:=0;
  repeat
    if (s [b] = #39) or (s = '"') then quote:=quote xor 1;
    if (s [b] = ';') and (quote = 0) then t:=';';
    inc (b);
  until (b > length (s)) or (t = ';');
  if (t = ';') then dec (b);
  if (b = 1) then
  begin
    f4:=s;
    delete (f4, 1, 1);
    kill_leadspace (f4);
    exit;
  end;
  if (b > 0) and (b <= length (s)) then
  begin
    f4:=s;
    delete (f4, 1, b);
    delete (s, b, length (s)-b+1);
  end;

  b:=pos (' ', s);
  if (b = 0) then
  begin
    f1:=s;
    s:='';
  end else
  begin
    f1:=copy (s, 1, b-1);
    delete (s, 1, b);
    kill_leadspace (s);
  end;

  t:='';
  quote:=0;
  b:=1;
  repeat
    if (s [b] = #39) or (s [b] = '"') then quote:=quote xor 1;
    if (s [b] = ' ') and (quote = 0) then t:=' ';
    inc (b);
  until (b > length (s)) or (t = ' ');
  if (t = ' ') then dec (b);
  if (b = 0) then
  begin
    f2:=s;
    s:='';
  end else
  begin
    f2:=copy (s, 1, b-1);
    delete (s, 1, b);
    kill_leadspace (s);
  end;

  f3:=s;

  kill_followspace (f1);
  kill_followspace (f2);
  kill_followspace (f3);

  if (length (f1) = 3) or
     ((length (f1) = 5) and (f1 [4] = '.')) then
     begin
       t:=upper (copy (f1, 1, 3));
       b:=0;
       repeat
         inc (b);
       until (b = mne_count) or (t = mne_word [b]);
       if (b < mne_count) then
       begin
         f3:=f2+f3;
         f2:=f1;
         f1:='';
       end;
     end;
  if ((length (f1) = 2) and ((upper (f1) = 'DC') OR (upper (f1) = 'DS'))) or
     ((length (f1) = 4) and ((upper (copy (f1, 1, 3)) = 'DC.') or (upper (copy (f1, 1, 3)) = 'DC.'))) then
  begin
    f3:=f2+' '+f3;
    f2:=f1;
    f1:='';
  end;
end;

procedure convert_negatives (var equ: string);
var b: byte;
    s: string;
begin
  b:=length (equ);
  while (b > 0) do
  begin
    if (equ [b] = '-') then insert ('+', equ, b);
    dec (b);
  end;     
end;

procedure convert_hex (var equ: string);
var b, b1, b2: byte;
    n: longint;
    s: string;
    e: integer;
begin
  while (pos ('$', equ) > 0) do
  begin
    b:=pos ('$', equ);
    b1:=b;
    b2:=b;
    repeat
      inc (b2);
    until (b2 > length (equ)) or (equ [b2] in ['+','*','/']);
    s:=copy (equ, b1+1, b2-b1-1);
    n:=hextodec (s);
    delete (equ, b1, b2-b1);
    str (n, s);
    insert (s, equ, b1);
  end;
end;

procedure convert_bin (var equ: string);
var b, b1, b2: byte;
    n: longint;
    s: string;
    e: integer;
begin
  while (pos ('%', equ) > 0) do
  begin
    b:=pos ('%', equ);
    b1:=b;
    b2:=b;
    repeat
      inc (b2);
    until (b2 > length (equ)) or not (equ [b2] in ['0','1']);
    s:=copy (equ, b1+1, b2-b1-1);
    n:=bintodec (s);
    delete (equ, b1, b2-b1);
    str (n, s);
    insert (s, equ, b1);
  end;
end;

procedure convert_asterisk (var equ: string);
var b: byte;
    s: string;
    e: integer;
begin
  b:=length (equ);
  while (b > 0) do
  begin
    if (equ [b] = '*') then
    begin
      if (equ [b-1] in ['+','*','/']) or
         (equ [b+1] in ['+','*','/']) then
      begin
        delete (equ, b, 1);
        str (address_index, s);
        insert (s, equ, b);
      end;
    end;
    dec (b);
  end;
end;

procedure convert_labels (var equ: string);
var b, b1, b2, e: byte;
    n: longint;
    s: string;
begin
  b:=length (equ);
  while (b > 0) do
  begin
    if (equ [b] = '_') or
       ((equ [b] >= 'A') and (equ [b] <= 'Z')) or
       ((equ [b] >= 'a') and (equ [b] <= 'z')) then
    begin
      b1:=b;
      repeat
        dec (b1);
      until (b1 = 0) or (equ [b1] in ['+','*','/','<','>']);
      inc (b1);
      if (equ [b1] = '_') or
       ((equ [b1] >= 'A') and (equ [b1] <= 'Z')) or
       ((equ [b1] >= 'a') and (equ [b1] <= 'z')) then
      begin
        b2:=b1;
        repeat
          inc (b2);
        until (b2 > length (equ)) or (equ [b2] in ['+','*','/','<','>']);
        s:=copy (equ, b1, b2-b1);
        e:=0;
        delete (equ, b1, b2-b1);
        n:=find_label (s);
        if (n < $ffff) then n:=label_list [n]^.address else
        begin
          n:=0;
          inc (err_flag);
          if (pass = 2) then show_error ('Undefined label in '+s);
        end;
        str (n, s);
        insert (s, equ, b1);
      end;
      b:=b1;
    end;
    dec (b);
  end;     
end;

procedure find_multiply (var equ: string);
var b, b1, b2: byte;
    n, n1, n2: longint;
    s: string;
    e: integer;
begin
  while (pos ('*', equ) > 0) do
  begin
    b:=pos ('*', equ);
    b1:=b;
    repeat
      dec (b1);
    until (b1 = 0) or (equ [b1] in ['+','*','/']);
    b2:=b;
    repeat
      inc (b2);
    until (b2 > length (equ)) or (equ [b2] in ['+','*','/']);
    s:=copy (equ, b1+1, b-b1-1);
    val (s, n1, e);
    s:=copy (equ, b+1, b2-b-1);
    val (s, n2, e);
    delete (equ, b1+1, b2-b1-1);
    n:=n1*n2;
    str (n, s);
    insert (s, equ, b1+1);
  end;
end;

procedure find_divide (var equ: string);
var b, b1, b2: byte;
    n, n1, n2: longint;
    s: string;
    e: integer;
begin
  while (pos ('/', equ) > 0) do
  begin
    b:=pos ('/', equ);
    b1:=b;
    repeat
      dec (b1);
    until (b1 = 0) or (equ [b1] in ['+','*','/']);
    b2:=b;
    repeat
      inc (b2);
    until (b2 > length (equ)) or (equ [b2] in ['+','*','/']);
    s:=copy (equ, b1+1, b-b1-1);
    val (s, n1, e);
    s:=copy (equ, b+1, b2-b-1);
    val (s, n2, e);
    delete (equ, b1+1, b2-b1-1);
    n:=n1 div n2;
    str (n, s);
    insert (s, equ, b1+1);
  end;
end;

procedure find_add (var equ: string);
var b, b1, b2: byte;
    n, n1, n2: longint;
    s: string;
    e: integer;
begin
  while (pos ('+', equ) > 0) do
  begin
    b:=pos ('+', equ);
    b1:=b;
    repeat
      dec (b1);
    until (b1 = 0) or (equ [b1] in ['+','*','/']);
    b2:=b;
    repeat
      inc (b2);
    until (b2 > length (equ)) or (equ [b2] in ['+','*','/']);
    s:=copy (equ, b1+1, b-b1-1);
    val (s, n1, e);
    s:=copy (equ, b+1, b2-b-1);
    val (s, n2, e);
    delete (equ, b1+1, b2-b1-1);
    n:=n1+n2;
    str (n, s);
    insert (s, equ, b1+1);
  end;
end;

function eval (equ: string): longint;
var l: longint;
    e: integer;
    lobyte,hibyte: byte;
begin
  err_flag:=0;
  if (equ = '-') then
  begin
    eval:=last_label;
    exit;
  end;
  if (equ [1] = '<') then
  begin
    lobyte:=1;
    delete (equ, 1, 1);
  end else lobyte:=0;
  if (equ [1] = '>') then
  begin
    hibyte:=1;
    delete (equ, 1, 1);
  end else hibyte:=0;
  convert_negatives (equ);
  convert_hex (equ);
  convert_bin (equ);
  convert_asterisk (equ);
  convert_labels (equ);
  find_multiply (equ);
  find_divide (equ);
  find_add (equ);
  val (equ, l, e);
  if (lobyte = 1) then eval:=lo(l) else
    if (hibyte = 1) then eval:=hi(l) else
      eval:=l;
end;

procedure addr_immediate (mne_op: byte);
var s: string;
    l: longint;
begin
  opcode_list:=dectohex (mne_op, 2)+' ';
  s:=copy (f3, 2, length (f3)-1);
  l:=eval (s);
  s:=copy (f2, 4, 2);
  if ((s = '.L') or (s = '.W') or (s = '.V')) and (l > -32768) and (l < 65536) then
  begin
    opcode_count:=3;
    opcode_list:=opcode_list+
                 dectohex (l and 255, 2)+' '+
                 dectohex ((l shr 8) and 255, 2);
    exit;
  end;
  if (l > -128) and (l < 256) then
  begin
    opcode_count:=2;
    opcode_list:=opcode_list+
                 dectohex (l, 2);
    exit;
  end;
  if (l > -32768) and (l < 65536) then
  begin
    opcode_count:=3;
    opcode_list:=opcode_list+
                 dectohex (l and 255, 2)+' '+
                 dectohex ((l shr 8) and 255, 2);
    exit;
  end;
  show_error ('Operand out of range '+operand);
  opcode_list:=opcode_list+'00';
  opcode_count:=2;
end;

procedure addr_absolute (mne_op: byte);
var s: string;
    l: longint;
    b: byte;
begin
  l:=eval (f3);
  s:=copy (f2, 4, 2);
  if (s = '.L') then
  begin
    opcode_count:=4;
    opcode_list:='00 00 00 00';
    if (no_long = 1) then
    begin
      show_error ('Absolute long addressing not valid for '+operator);
      exit;
    end;
    if (l > -8388608) and (l < 16777216) then
    begin
      opcode_list:=dectohex (mne_op+$02, 2)+' '+
                   dectohex (l and 255, 2)+' '+
                   dectohex ((l shr 8) and 255, 2)+' '+
                   dectohex ((l shr 16) and 255, 2);
      exit;
    end;
    show_error ('Operand out of range '+operand+', requires $000000-$FFFFFF');
    exit;
  end;
  if (s = '.W') then
  begin
    opcode_count:=3;
    opcode_list:='00 00 00';
    if (no_word = 1) then
    begin
      show_error ('Absolute addressing not valid for '+operator);
      exit;
    end;
    if (l > -32768) and (l < 65536) then
    begin
      opcode_list:=dectohex (mne_op, 2)+' '+
                   dectohex (l and 255, 2)+' '+
                   dectohex ((l shr 8) and 255, 2);
      exit;
    end;
    show_error ('Operand out of range '+operand+', requires $0000-$FFFF');
    exit;
  end;
  if (s = '.B') then
  begin
    opcode_count:=2;
    opcode_list:='00 00';
    if (no_byte = 1) then
    begin
      show_error ('Direct addressing not valid for '+operator);
      exit;
    end;
    if (l > -128) and (l < 256) then
    begin
      opcode_list:=dectohex (mne_op-$08, 2)+' '+
                   dectohex (l and 255, 2);
      exit;
    end;
    show_error ('Operand out of range '+operand+', requires $00-$FF');
    exit;
  end;

  if (l and $ff0000 = address_index and $ff0000) then l:=l and $00ffff;
  opcode_count:=3;
  opcode_list:='00 00 00';
  if (err_flag > 0) then exit;
  if (l > -128) and (l < 256) and (no_byte = 0) then
  begin
    opcode_count:=2;
    opcode_list:=dectohex (mne_op-$08, 2)+' '+
                 dectohex (l and 255, 2);
    exit;
  end;
  if (l > -32768) and (l < 65536) and (no_word = 0) then
  begin
    opcode_count:=3;
    opcode_list:=dectohex (mne_op, 2)+' '+
                 dectohex (l and 255, 2)+' '+
                 dectohex ((l shr 8) and 255, 2);
    exit;
  end;
  if (l > -8388608) and (l < 16777216) and (no_long = 0) then
  begin
    opcode_count:=4;
    opcode_list:=dectohex (mne_op+$02, 2)+' '+
                 dectohex (l and 255, 2)+' '+
                 dectohex ((l shr 8) and 255, 2)+' '+
                 dectohex ((l shr 16) and 255, 2);
    exit;
  end;
  show_error ('Operand out of range '+operand);
end;

procedure addr_indirect (mne_op: byte);
var s: string;
    l: longint;
    b: byte;
begin
  l:=eval (f3);
  s:=copy (f2, 4, 2);
  if (s = '.L') then
  begin
    opcode_count:=4;
    opcode_list:='00 00 00 00';
    if (no_long = 1) then
    begin
      show_error ('Direct indirect long addressing not valid for '+operator);
      exit;
    end;
    if (l > -8388608) and (l < 16777216) then
    begin
      opcode_list:=dectohex (mne_op+$02, 2)+' '+
                   dectohex (l and 255, 2)+' '+
                   dectohex ((l shr 8) and 255, 2)+' '+
                   dectohex ((l shr 16) and 255, 2);
      exit;
    end;
    show_error ('Operand out of range '+operand+', requires $000000-$FFFFFF');
    exit;
  end;
  if (s = '.W') then
  begin
    opcode_count:=3;
    opcode_list:='00 00 00';
    if (no_word = 1) then
    begin
      show_error ('Direct indirect addressing not valid for '+operator);
      exit;
    end;
    if (l > -32768) and (l < 65536) then
    begin
      opcode_list:=dectohex (mne_op, 2)+' '+
                   dectohex (l and 255, 2)+' '+
                   dectohex ((l shr 8) and 255, 2);
      exit;
    end;
    show_error ('Operand out of range '+operand+', requires $0000-$FFFF');
    exit;
  end;
  if (s = '.B') then
  begin
    opcode_count:=2;
    opcode_list:='00 00';
    if (no_byte = 1) then
    begin
      show_error ('Direct indirect addressing not valid for '+operator);
      exit;
    end;
    if (l > -128) and (l < 256) then
    begin
      opcode_list:=dectohex (mne_op-$08, 2)+' '+
                   dectohex (l and 255, 2);
      exit;
    end;
    show_error ('Operand out of range '+operand+', requires $00-$FF');
    exit;
  end;

  if (l > -128) and (l < 256) and (no_byte = 0) then
  begin
    opcode_count:=2;
    opcode_list:=dectohex (mne_op-$08, 2)+' '+
                 dectohex (l and 255, 2);
    exit;
  end;
  if (l > -32768) and (l < 65536) and (no_word = 0) then
  begin
    opcode_count:=3;
    opcode_list:=dectohex (mne_op, 2)+' '+
                 dectohex (l and 255, 2)+' '+
                 dectohex ((l shr 8) and 255, 2);
    exit;
  end;
  if (l > -8388608) and (l < 16777216) and (no_long = 0) then
  begin
    opcode_count:=4;
    opcode_list:=dectohex (mne_op+$02, 2)+' '+
                 dectohex (l and 255, 2)+' '+
                 dectohex ((l shr 8) and 255, 2)+' '+
                 dectohex ((l shr 16) and 255, 2);
    exit;
  end;
  show_error ('Operand out of range '+operand);
  opcode_count:=2;
  opcode_list:='00 00';
end;

function find_addressing_mode (s: string): byte;
begin
  find_addressing_mode:=0;
  if (s [1] = '#') then
  begin
    find_addressing_mode:=1;
    exit;
  end;
  if (pos ('(', s) > 0) and (pos (')', s) > 0) then
  begin
    if (pos (',S),Y', s) > 0) then find_addressing_mode:=23 else
      if (pos (',X)', s) > 0) then find_addressing_mode:=21 else
        if (pos ('),Y', s) > 0) then find_addressing_mode:=22 else
          if (pos (',', s) = 0) then find_addressing_mode:=20;
    exit;
  end;
  if (pos ('[', s) > 0) and (pos (']', s) > 0) then
  begin
    if (pos (',S', s) > 0) or (pos (',X', s) > 0) then exit else
      if (pos ('],Y', s) > 0) then find_addressing_mode:=32 else
        if (pos (',Y', s) = 0) then find_addressing_mode:=30;
    exit;
  end;
  if (pos (',X', s) > 0) then find_addressing_mode:=11 else
    if (pos (',Y', s) > 0) then find_addressing_mode:=12 else
      if (pos (',S', s) > 0) then find_addressing_mode:=13 else
        if (pos (',', s) = 0) then find_addressing_mode:=10;
end;

procedure type00 (mne_op: byte);
begin
  if (operand <> '') then show_error ('Ignoring unexpected operand '+operand);
  opcode_count:=1;
  opcode_list:=dectohex (mne_op, 2);
end;

procedure type01 (mne_op: byte);
var b: byte;
begin
  if (operand = '') then show_error ('No operand') else
  begin
    b:=find_addressing_mode (f3);
    case b of
      1:
      begin
        addr_immediate (mne_op+$08);
        exit;
      end;
      10:
      begin
        addr_absolute (mne_op+$0c);
        exit;
      end;
      11:
      begin
        delete (f3, pos (',X', f3), 2);
        addr_absolute (mne_op+$1c);
        exit;
      end;
      12:
      begin
        no_byte:=1;
        no_long:=1;
        delete (f3, pos (',Y', f3), 2);
        addr_absolute (mne_op+$18);
        exit;
      end;
      13:
      begin
        no_word:=1;
        no_long:=1;
        delete (f3, pos (',S', f3), 2);
        addr_absolute (mne_op+$0a);
        exit;
      end;
      20:
      begin
        no_word:=1;
        no_long:=1;
        delete (f3, pos ('(', f3), 1);
        delete (f3, pos (')', f3), 1);
        addr_indirect (mne_op+$19);
        exit;
      end;
      21:
      begin
        no_word:=1;
        no_long:=1;
        delete (f3, pos ('(', f3), 1);
        delete (f3, pos (',X)', f3), 3);
        addr_indirect (mne_op+$08);
        exit;
      end;
      22:
      begin
        no_word:=1;
        no_long:=1;
        delete (f3, pos ('(', f3), 1);
        delete (f3, pos ('),Y', f3), 3);
        addr_indirect (mne_op+$18);
        exit;
      end;
      23:
      begin
        no_word:=1;
        no_long:=1;
        delete (f3, pos ('(', f3), 1);
        delete (f3, pos (',S),Y', f3), 5);
        addr_indirect (mne_op+$1a);
        exit;
      end;
      30:
      begin
        no_word:=1;
        no_long:=1;
        delete (f3, pos ('[', f3), 1);
        delete (f3, pos (']', f3), 1);
        addr_indirect (mne_op+$0e);
        exit;
      end;
      32:
      begin
        no_word:=1;
        no_long:=1;
        delete (f3, pos ('[', f3), 1);
        delete (f3, pos ('],Y', f3), 3);
        addr_indirect (mne_op+$1e);
        exit;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

procedure type02 (mne_op: byte);
var b: byte;
begin
  if (operand = '') then show_error ('No operand') else
  begin
    b:=find_addressing_mode (f3);
    case b of
      10:
      begin
        no_long:=1;
        addr_absolute (mne_op+$08);
        exit;
      end;
      11:
      begin
        if (pos ('STX', f2) = 0) then
        begin
          no_word:=1;
          no_long:=1;
          delete (f3, pos (',X', f3), 2);
          addr_absolute (mne_op+$18);
          exit;
        end;
      end;
      12:
      begin
        no_word:=1;
        no_long:=1;
        if (pos ('STY', f2) = 0) then
        begin
          delete (f3, pos (',Y', f3), 2);
          addr_absolute (mne_op+$18);
          exit;
        end;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

procedure type03 (mne_op: byte);
var b: byte;
begin
  if (operand = '') then
  begin
    opcode_count:=1;
    opcode_list:=dectohex (mne_op+$04, 2);
    exit;
  end else
  begin
    no_long:=1;
    b:=find_addressing_mode (f3);
    case b of
      10:
      begin
        addr_absolute (mne_op+$08);
        exit;
      end;
      11:
      begin
        delete (f3, pos (',X', f3), 2);
        addr_absolute (mne_op+$18);
        exit;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

procedure type04 (mne_op: byte);
var b: byte;
begin
  if (operand = '') then
  begin
    opcode_count:=1;
    if (f2 = 'DEC') then opcode_list:=dectohex ($3a, 2);
    if (f2 = 'INC') then opcode_list:=dectohex ($1a, 2);
    exit;
  end else
  begin
    no_long:=1;
    b:=find_addressing_mode (f3);
    case b of
      10:
      begin
        addr_absolute (mne_op+$08);
        exit;
      end;
      11:
      begin
        delete (f3, pos (',X', f3), 2);
        addr_absolute (mne_op+$18);
        exit;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

procedure type05 (mne_op: byte);
var b: byte;
begin
  if (operand = '') then show_error ('No operand') else
  begin
    b:=find_addressing_mode (f3);
    case b of
      1:
      begin
        addr_immediate (mne_op);
        exit;
      end;
      10:
      begin
        no_long:=1;
        addr_absolute (mne_op+$0c);
        exit;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

procedure type06 (mne_op: byte);
var b: byte;
begin
  if (operand = '') then show_error ('No operand') else
  begin
    b:=find_addressing_mode (f3);
    case b of
      1:
      begin
        addr_immediate (mne_op);
        exit;
      end;
      10:
      begin
        no_long:=1;
        addr_absolute (mne_op+$0c);
        exit;
      end;
      11:
      begin
        if (pos ('LDX', f2) = 0) then
        begin
          no_long:=1;
          delete (f3, pos (',X', f3), 2);
          addr_absolute (mne_op+$1c);
          exit;
        end;
      end;
      12:
      begin
        if (pos ('LDY', f2) = 0) then
        begin
          no_long:=1;
          delete (f3, pos (',Y', f3), 2);
          addr_absolute (mne_op+$1c);
          exit;
        end;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

procedure type07 (mne_op: byte);
var b: byte;
    l: longint;
begin
  if (operand = '') then show_error ('No operand') else
  begin
    b:=find_addressing_mode (f3);
    case b of
      10:
      begin
        no_byte:=1;
        addr_absolute (mne_op);
        if (opcode_count = 4) then
        begin
          no_word:=1;
          addr_absolute (mne_op+$0e);
        end;
        exit;
      end;
      20:
      begin
        no_byte:=1;
        no_long:=1;
        delete (f3, pos ('(', f3), 1);
        delete (f3, pos (')', f3), 1);
        addr_indirect (mne_op+$20);
        exit;
      end;
      21:
      begin
        no_byte:=1;
        no_long:=1;
        delete (f3, pos ('(', f3), 1);
        delete (f3, pos (',X)', f3), 3);
        addr_indirect (mne_op+$30);
        exit;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

procedure type08 (mne_op: byte);
var b: byte;
    l: longint;
begin
  if (operand = '') then show_error ('No operand') else
  begin
    b:=find_addressing_mode (f3);
    case b of
      10:
      begin
        no_byte:=0;
        no_word:=0;
        f2:=f2+'.L';
        addr_absolute (mne_op-$82);
        exit;
      end;
      20:
      begin
        no_byte:=1;
        no_long:=1;
        delete (f3, pos ('(', f3), 1);
        delete (f3, pos (')', f3), 1);
        addr_indirect (mne_op);
        exit;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

procedure type09 (mne_op: byte);
var b: byte;
    l: longint;
begin
  if (operand = '') then show_error ('No operand') else
  begin
    b:=find_addressing_mode (f3);
    case b of
      10:
      begin
        no_byte:=1;
        addr_absolute (mne_op);
        exit;
      end;
      21:
      begin
        no_byte:=1;
        no_long:=1;
        delete (f3, pos ('(', f3), 1);
        delete (f3, pos (',X)', f3), 3);
        addr_indirect (mne_op+$dc);
        exit;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

procedure type0a (mne_op: byte);
var b: byte;
    l: longint;
begin
  if (operand = '') then show_error ('No operand') else
  begin
    b:=find_addressing_mode (f3);
    case b of
      10:
      begin
        no_byte:=1;
        no_word:=1;
        addr_absolute (mne_op-$02);
        exit;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

procedure type0b (mne_op: byte);
var b: byte;
begin
  if (operand = '') then show_error ('No operand') else
  begin
    no_long:=1;
    b:=find_addressing_mode (f3);
    case b of
      1:
      begin
        addr_immediate ($89);
        exit;
      end;
      10:
      begin
        addr_absolute (mne_op+$08);
        exit;
      end;
      11:
      begin
        delete (f3, pos (',X', f3), 2);
        addr_absolute (mne_op+$18);
        exit;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

procedure type0c (mne_op: byte);
var b: byte;
    l1, l2: longint;
begin
  b:=0;
  if (operand = '') then show_error ('No operand') else
  begin
    if (pass = 2) then
    begin
      l2:=eval (f3);
      if (err_flag = 0) then
      begin
        l1:=l2-(address_index+2);
        if (l1 < -128) or (l1 > 127) then show_error ('Branch out of range') else
          b:=l1;
      end;
    end;
  end;
  opcode_count:=2;
  if (pass = 2) then opcode_list:=dectohex (mne_op, 2)+' '+dectohex (b, 2);
end;

procedure type0d (mne_op: byte);
var w: byte;
    l: longint;
begin
  w:=0;
  if (operand = '') then show_error ('No operand') else
  begin
    if (pass = 2) then
    begin
      l:=eval (f3)-(address_index+3);
      if (err_flag = 0) then
      begin
        if (l < -32768) or (l > 32767) then show_error ('Branch out of range') else
          w:=l;
      end;
    end;
  end;
  opcode_count:=2;
  if (pass = 2) then opcode_list:=dectohex (mne_op, 2)+' '+
                                  dectohex (w and 255, 2)+' '+
                                  dectohex ((w shr 8) and 255, 2);
end;

procedure type0e (mne_op: byte);
var b: byte;
    l1, l2: longint;
    s: string;
begin
  if (operand = '') then show_error ('No operand') else
  begin
    b:=pos (',', f3);
    if (b > 0) then
    begin
      s:=copy (f3, 1, b-1);
      l1:=eval (s);
      s:=copy (f3, b+1, length (f3)-b+1);
      l2:=eval (s);
      if (l1 < -80) or (l1 > 255) or
         (l2 < -80) or (l2 > 255) then show_error ('Operand out of range '+operand) else
        begin
          opcode_count:=2;
          opcode_list:=dectohex (mne_op, 2)+' '+
                       dectohex (l2, 2)+' '+
                       dectohex (l1, 2)+' ';
          exit;
        end;
    end;
    show_error ('Illegal addressing mode');
  end;
end;
     
procedure type0f (mne_op: byte);
var b: byte;
begin
  if (operand = '') then show_error ('No operand') else
  begin
    b:=find_addressing_mode (f3);
    case b of
      10:
      begin
        no_byte:=1;
        no_long:=1;
        addr_absolute (mne_op);
        exit;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

procedure type10 (mne_op: byte);
var b: byte;
begin
  if (operand = '') then show_error ('No operand') else
  begin
    b:=find_addressing_mode (f3);
    case b of
      20:
      begin
        no_word:=1;
        no_long:=1;
        delete (f3, pos ('(', f3), 1);
        delete (f3, pos (')', f3), 1);
        addr_indirect (mne_op+$08);
        exit;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

procedure type11 (mne_op: byte);
var b: byte;
begin
  if (operand = '') then show_error ('No operand') else
  begin
    b:=find_addressing_mode (f3);
    case b of
      1:
      begin
        no_word:=1;
        no_long:=1;
        addr_immediate (mne_op);
        exit;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

procedure type12 (mne_op: byte);
var b: byte;
begin
  if (operand = '') then show_error ('No operand') else
  begin
    no_long:=1;
    b:=find_addressing_mode (f3);
    case b of
      10:
      begin
        addr_absolute (mne_op+$38);
        if (opcode_count = 2) then
        begin
          no_word:=1;
          addr_absolute (mne_op+$08);
        end;
        exit;
      end;
      11:
      begin
        delete (f3, pos (',X', f3), 2);
        addr_absolute (mne_op+$3a);
        if (opcode_count = 2) then
        begin
          no_word:=1;
          addr_absolute (mne_op+$18);
        end;
        exit;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

procedure type13 (mne_op: byte);
var b: byte;
begin
  if (operand = '') then show_error ('No operand') else
  begin
    no_long:=1;
    b:=find_addressing_mode (f3);
    case b of
      10:
      begin
        addr_absolute (mne_op+$08);
        exit;
      end;
    end;
  end;
  show_error ('Illegal addressing mode');
end;

function find_mnemonic (s: string): word;
var b: byte;
begin
  b:=0;
  repeat
    inc (b);
  until (b = mne_count) or (mne_word [b] = s);
  if (b < mne_count) then find_mnemonic:=b else
    find_mnemonic:=$ffff;
end;

procedure binary_load;
var l: longint;
    f: file;
    w, c: word;
    buf: array [0..1023] of byte;
begin
  assign (f, f3);
  {$I-}
  reset (f, 1);
  if (ioresult = 0) then
  begin
    l:=filesize (f);
    if (l > 32768) then l:=(l div 32768)*65536;
    opcode_count:=l;
    write_op:=0;
    if (pass = 2) then
    begin
      repeat
        blockread (f, buf, sizeof (buf), w);
        blockwrite (obj_file, buf, w);
      until (w = 0);
    end;
    close (f);
  end else show_error ('Error reading binary file '+f3);
  {$I+}
end;

procedure pad_file;
var l, c: longint;
    buf: array [0..32767] of byte;
begin
  fillchar (buf, 32768, 0);
  if (f3 <> '') then
  begin
    l:=eval (f3);
    if (l >= $8000) and (l <= $ffff) then
    begin
      l:=l+(address_index and $ff0000);
      if (l < address_index) then
      begin
        l:=l+$010000;
        if (pass = 2) then
        begin
          c:=$8000-(address_index and $7fff);
          blockwrite (obj_file, buf [start_address and $7fff], c);
          inc (address_index, c);
        end;
      end;
      if (pass = 2) then
      begin
        c:=(l and $7fff)-(address_index and $7fff);
        blockwrite (obj_file, buf [address_index and $7fff], c);
      end;
      address_index:=l;
    end else
    begin
      show_error ('Illegal PAD operand '+f3+', padding to next bank.');
      f3:='';
    end;
  end;
  if (f3 = '') then
  begin
    write_op:=0;
    l:=((address_index+65536) and $ff0000) or $8000;
    opcode_count:=l-address_index;
    if (pass = 2) then
    begin
      c:=$8000-(address_index and $7fff);
      blockwrite (obj_file, buf [address_index and $7fff], c);
    end;
  end;
end;

procedure data_string_byte;
var b, b1, b2: byte;
    s, t: string;
    l: longint;
    quote1, quote2: byte;
begin
  opcode_count:=0;
  opcode_list:='';
  b:=1;
  f3:=f3+',';
  quote1:=0;
  repeat
    if (f3 [b] = '"') then quote1:=quote1 xor 1;
    if (f3 [b] = ',') and (quote1 = 0) then
    begin
      t:='';
      quote2:=0;
      b1:=b;
      b2:=b;
      repeat
        dec (b1);
        if (f3 [b1] = '"') then quote2:=quote2 xor 1;
        if (f3 [b1] = ',') and (quote2 = 0) then t:=',';
      until (b1 <= 0) or (t = ',');
      if (t = ',') then inc (b1) else dec (b2);
      s:=copy (operand, b1, b2-b1);
      kill_leadspace (s);
      kill_followspace (s);
      if (s [1] = '"') then
      begin
        b1:=1+1;
        while (b1 <= length (s)) and (s [b1] <> s [1]) do
        begin
          if (pass = 2) then opcode_list:=opcode_list+dectohex (ord (s [b1]), 2)+' ';
          inc (opcode_count);
          inc (b1);
        end;
      end else
      begin
        l:=eval (upper (s));
        if (l <-128) or (l > 255) then show_error ('Data size too large, truncating');
        if (pass = 2) then opcode_list:=opcode_list+dectohex (l and 255, 2)+' ';
        inc (opcode_count);
      end;
    end;
    inc (b);
  until (b > length (f3));
  delete (f3, length (f3), 1);
end;

procedure data_string_word;
var b, b1, b2: byte;
    s, t: string;
    l: longint;
    quote1, quote2: byte;
begin
  opcode_count:=0;
  opcode_list:='';
  b:=1;
  f3:=f3+',';
  quote1:=0;
  repeat
    if (f3 [b] = '"') then quote1:=quote1 xor 1;
    if (f3 [b] = ',') and (quote1 = 0) then
    begin
      t:='';
      quote2:=0;
      b1:=b;
      b2:=b;
      repeat
        dec (b1);
        if (f3 [b1] = '"') then quote2:=quote2 xor 1;
        if (f3 [b1] = ',') and (quote2 = 0) then t:=',';
      until (b1 <= 0) or (t = ',');
      if (t = ',') then inc (b1) else dec (b2);
      s:=copy (operand, b1, b2-b1);
      kill_leadspace (s);
      kill_followspace (s);
      if (s [1] = '"') then
      begin
        b1:=1+1;
        while (b1 <= length (s)) and (s [b1] <> s [1]) do
        begin
          if (pass = 2) then opcode_list:=opcode_list+dectohex (ord (s [b1]), 2)+' ';
          inc (opcode_count);
          inc (b1);
        end;
      end else
      begin
        l:=eval (upper (s));
        if (l <-32768) or (l > 65535) then show_error ('Data size too large, truncating');
        if (pass = 2) then opcode_list:=opcode_list+dectohex (l and 255, 2)+' '+
                                                    dectohex ((l shr 8) and 255, 2)+' ';
        inc (opcode_count,2);
      end;
    end;
    inc (b);
  until (b > length (f3));
  delete (f3, length (f3), 1);
end;

procedure data_buffer_byte;
var l: longint;
    buf: array [0..32767] of byte;
begin
  fillchar (buf, 32768, 0);
  l:=eval (f3);
  if (l < 0) or (l > 32768) then show_error ('Data buffer area cannot exceed 32768 bytes') else
  begin
    address_index:=address_index+l;
    if (pass = 2) then blockwrite (obj_file, buf, l);
  end;
end;

procedure data_buffer_word;
var l: longint;
    buf: array [0..32767] of byte;
begin
  fillchar (buf, 32768, 0);
  l:=eval (f3);
  if (l < 0) or (l > 32768) then show_error ('Data buffer area cannot exceed 32768 words') else
  begin
    address_index:=address_index+l;
    if (pass = 2) then
    begin
      blockwrite (obj_file, buf, l);
      blockwrite (obj_file, buf, l);
    end;
  end;
end;

procedure assemble_line;
var s: string;
    l: longint;
    w: word;
    b: byte;
    mne_index, mne_op: byte;
    lab: label_rec;
begin
  s:=copy (f2, 1, 3);
  if (s = 'ORG') or (s = 'NAM') or (s = 'COU') or (s = 'VER') then exit;

  if (s = 'INT') then
  begin
    exit
  end;

  if (s = 'BIN') then
  begin
    binary_load;
    exit;
  end;

  if (s = 'PAD') then
  begin
    pad_file;
    exit;
  end;

  if (s = 'EQU') or (s = '=') then
  begin
    l:=eval (f3);
    w:=find_label (f1);
    if (pass = 1) then
    begin
      if (w = $ffff) then
      begin
        if (err_flag > 0) then save_new_label (f1, l, 129) else
          save_new_label (f1, l, 1);
      end else show_error ('Duplicate label '+_label);
      exit;
    end;
    if (pass = 2) then
    begin
      lab:=label_list [w]^;
      if (lab.pass = 129) then
      begin
        lab.pass:=2;
        lab.address:=l;
        label_list [w]^:=lab;
        exit;
      end;
      if (lab.pass = 1) then
      begin
        lab.pass:=2;
        lab.address:=l;
        label_list [w]^:=lab;
        exit;
      end;
      show_error ('Duplicate label '+_label);
      exit;
    end;
  end;

  if (f1 <> '') and (pass = 1) then
  begin
    if (f1 = '-') then
    begin
      last_label:=address_index;
    end else
    begin
      w:=find_label (f1);
      if (w = $ffff) then
      begin
        save_new_label (f1, address_index, 1);
      end else show_error ('Duplicate label '+_label);
    end;
  end;

  if (f1 <> '') and (pass = 2) then
  begin
    if (f1 = '-') then
    begin
      last_label:=address_index
    end else
    begin
      w:=find_label (f1);
      lab:=label_list [w]^;
      if (lab.pass = 1) then
      begin
        lab.address:=address_index;
        lab.pass:=2;
        label_list [w]^:=lab;
      end else show_error ('Duplicate label '+_label);
    end;
  end;

  if (f2 = '') and (f3 = '') then exit;

  if (f2 = 'DCB') or (f2 = 'DC.B') or (f2 = 'DB') or (f2 = 'DC') then
  begin
    data_string_byte;
    exit;
  end;
  if (f2 = 'DCW') or (f2 = 'DC.W') or (f2 = 'DW') then
  begin
    data_string_word;
    exit;
  end;

  if (f2 = 'DSB') or (f2 = 'DS.B') or (f2 = 'DS') then
  begin
    data_buffer_byte;
    exit;
  end;
  if (f2 = 'DSW') or (f2 = 'DS.W') then
  begin
    data_buffer_word;
    exit;
  end;

  if (length (f2) = 3) or
     ((length (f2) = 5) and (f2 [4] = '.')) then
  begin
    opcode_count:=1;
    opcode_list:='00';
    no_byte:=0;
    no_long:=0;
    no_word:=0;
    mne_index:=find_mnemonic (s);
    mne_op:=mne_opcode [mne_index];
    if (mne_index >= 0) and (mne_index <= 255) then
    begin
      case mne_type [mne_index] of
        $00: type00 (mne_op);
        $01: type01 (mne_op);
        $02: type02 (mne_op);
        $03: type03 (mne_op);
        $04: type04 (mne_op);
        $05: type05 (mne_op);
        $06: type06 (mne_op);
        $07: type07 (mne_op);
        $08: type08 (mne_op);
        $09: type09 (mne_op);
        $0a: type0a (mne_op);
        $0b: type0b (mne_op);
        $0c: type0c (mne_op);
        $0d: type0d (mne_op);
        $0f: type0f (mne_op);
        $0e: type0e (mne_op);
        $10: type10 (mne_op);
        $11: type11 (mne_op);
        $12: type12 (mne_op);
        $13: type13 (mne_op);
      end;
    end else
    show_error ('Unknown operator');
  end;
end;

procedure do_pass0;
begin
  if (f2 = 'ORG') then start_address:=eval (f3);
  if (f2 = 'NAM') then name:=operand;
  if (f2 = 'COU') then country:=eval (f3);
  if (f2 = 'VER') then version:=eval (f3);
end;

procedure do_pass1;
var w: word;
    b: byte;
begin
  write_op:=1;
  opcode_count:=0;
  opcode_list:='';
  if (f1 <> '') or (f2 <> '') or (f3 <> '') then
  begin
    assemble_line;
  end;
  if (pass = 2) then
  begin
    if (save_lst > 0) then
    begin
      write (lst_file, adj_right (inttostr (line_index), 6, ' '), ' ',
                       dectohex (address_index, 6), '  ',
                       adj_left (opcode_list, 12, ' '), '  ',
                       adj_left (_label, 16, ' '),
                       adj_left (operator, 7, ' '),
                       adj_left (operand, 16, ' '));
      if (comment = '') then writeln (lst_file) else
        writeln (lst_file, '; ',comment);
    end;
    if (show_listings > 0) then
    begin
      write (adj_right (inttostr (line_index), 6, ' '), ' ',
             dectohex (address_index, 6), '  ',
             adj_left (opcode_list, 12, ' '), '  ',
             adj_left (_label, 16, ' '),
             adj_left (operator, 7, ' '),
             adj_left (operand, 16, ' '));
      if (comment = '') then writeln else
        writeln ('; ',comment);
    end;
    if (show_lines > 0) and (show_listings = 0) then
    begin
      writeln (adj_right (inttostr (line_index), 6, ' '), ' ',
               dectohex (address_index, 6));
    end;
    if (opcode_count > 0) and (write_op > 0) then
    begin
      for w:=0 to (opcode_count-1) do
      begin
        b:=hextodec (copy (opcode_list, (w*3)+1, 2));
        blockwrite (obj_file, b, 1);
      end;
    end;
  end;
  inc (address_index, opcode_count);
  address_index:=address_index or $8000;
end;

procedure process_pass;
var l: string;
begin
  assign (src_file, src_name);
  reset (src_file);
  if (ioresult = 0) then
  begin
    line_index:=0;
    address_index:=start_address;
    while not eof (src_file) do
    begin
      inc (line_index);
      readln (src_file, l);
      parse_line (l, _label, operator, operand, comment);
      f1:=upper (_label);
      f2:=upper (operator);
      f3:=upper (operand);
      f4:=comment;
      if (f1 [length (f1)] = ':') then
      begin
        delete (f1, length (f1), 1);
        kill_followspace (f1);
      end;
      if (pass = 0) then do_pass0;
      if (pass = 1) then do_pass1;
      if (pass = 2) then do_pass1;
    end;
    close (src_file);
  end else
  begin
    show_error ('Unable to read source file');
    close (err_file);
    if (save_lst > 0) then close (lst_file);
    halt (1);
  end;
end;

procedure pad_obj_file;
var l:longint;
    w:word;
    buf:array [0..32767] of byte;
begin
  fillchar (buf, 32768,0);
  buf [$7ffd]:=$80;
  assign (obj_file, obj_name);
  reset (obj_file, 1);
  l:=filesize (obj_file);
  seek (obj_file, l);
  blockwrite (obj_file, buf [l mod 32768], 32768-(l mod 32768));
  while (length (name) < 20) do name:=name+' ';
  name:=name+'0';
  seek (obj_file, $7fc0);
  blockwrite (obj_file, name [1], 21);
  name:=chr ($0b);
  seek (obj_file, $7fd7);
  blockwrite (obj_file, name [1], 1);
  name:=chr (country);
  seek (obj_file, $7fd9);
  blockwrite (obj_file, name [1], 1);
  name:=chr (version-1);
  seek (obj_file, $7fdb);
  blockwrite (obj_file, name [1], 1);
  name:=chr (start_address and 255)+
        chr ((start_address shr 8) and 255)+
        chr ((start_address shr 16) and 255);
  seek (obj_file, $7ffc);
  blockwrite (obj_file, name [1], 3);
  close (obj_file);

  reset (obj_file, 1);
  l:=filesize (obj_file);

  assign (smc_file, smc_name);
  rewrite (smc_file, 1);
  l:=l*8;
  buf[0]:=(l shr 16) and 255;
  buf[1]:=(l shr 8) and 255;
  buf[2]:=l and 255;
  blockwrite (smc_file, buf, 512);
  repeat
    blockread (obj_file, buf, 32768, w);
    blockwrite (smc_file, buf, w);
  until (w=0);
  close (obj_file);
  close (smc_file);
end;

procedure save_labels;
var w: word;
    l: label_rec;
begin
  if (label_index = 0) then exit;
  if (save_lab > 0) then
  begin
    assign (lab_file, lab_name);
    rewrite (lab_file);
    for w:=0 to (label_index-1) do
    begin
      l:=label_list [w]^;
      writeln (lab_file, adj_left (l.name, 16, ' '), ' = ', dectohex (l.address, 7));
    end;
    close (lab_file);
  end;
end;

begin
  writeln;
  writeln;
  writeln ('65c816 SNES Cross Assembler Version 1.05');
  writeln ('Coded by Norman Yen');
  writeln ('Released 04-29-93, Updated 11-06-93');
  writeln;
  if (paramcount = 0) then
  begin
    writeln ('Usage: SNESASM -<options> <source code>');
    writeln;
    writeln ('Options:');
    writeln ('   S.. Show listings to screen       L.. Save LST file');
    writeln ('   $.. Save LAB file                 #.. Show line numbers');
    writeln;
    writeln ('If no extension is given a default of .ASM will be used.');
    exit;
  end;

  show_listings:=0;
  save_lab:=0;
  save_lst:=0;
  show_lines:=0;

  if (copy (paramstr (1), 1, 1) = '-') or
     (copy (paramstr (1), 1, 1) = '/') then
  begin
    if (pos ('S', upper (paramstr (1))) > 0) then show_listings:=1;
    if (pos ('L', upper (paramstr (1))) > 0) then save_lst:=1;
    if (pos ('$', upper (paramstr (1))) > 0) then save_lab:=1;
    if (pos ('#', upper (paramstr (1))) > 0) then show_lines:=1;
    src_name:=paramstr (2);
  end else src_name:=paramstr (1);

  if (pos ('.', src_name) = 0) then src_name:=src_name+'.asm';
  obj_name:=copy (src_name,1, pos ('.', src_name))+'obj';
  smc_name:=copy (src_name,1, pos ('.', src_name))+'smc';
  err_name:=copy (src_name,1, pos ('.', src_name))+'err';
  lab_name:=copy (src_name,1, pos ('.', src_name))+'lab';
  lst_name:=copy (src_name,1, pos ('.', src_name))+'lst';

  assign (err_file, err_name);
  rewrite (err_file);
  if (save_lst > 0) then
  begin
    assign (lst_file, lst_name);
    rewrite (lst_file);
  end;

  start_address:=$008000;
  version:=1;
  country:=1;
  name:='(C) 1993 Norman Yen';
  get_label_mem;
  for pass:=0 to 2 do
  begin
    error_index:=0;
    write ('Pass ', pass);
    write (err_file, 'Pass ', pass);
    if (pass = 2) then
    begin
      assign (obj_file, obj_name);
      rewrite (obj_file, 1);
    end;
    process_pass;
    if (pass = 2) then
    begin
      close (obj_file);
      pad_obj_file;
    end;
    writeln (': ',line_index,' Lines, ',error_index, ' Errors, ',label_index, ' Labels');
    writeln (err_file,': ',line_index,' Lines, ',error_index, ' Errors, ',label_index, ' Labels');
  end;
  writeln (dectohex (start_address, 6),'-', dectohex (address_index, 6));
  writeln (err_file, dectohex (start_address, 6),'-', dectohex (address_index, 6));
  writeln;
  close (err_file);
  if (save_lst > 0) then close (lst_file);
  save_labels;
  free_label_mem;
end.
