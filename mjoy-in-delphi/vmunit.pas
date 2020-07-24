unit vmunit;

//maxstack im linker ?
interface

uses System.SysUtils//exception
     ;

const xnil = 0;
      maxproc = 1000;
      mjdef = '==';
      qot='''';
      special = ['(',')','[',']','{','}','"',qot];

type xtype=(xnull,xcons,xident,xint,xfloat,xchar,xstring);
     mjcell = record case xtype of
                          xnull:   ();
                          xcons:   (addr,decr: cardinal);
                          xident:  (pname,value: cardinal);
                          xint:    (inum: int64);//64 bit
                          xfloat:  (fnum: double);//64 bit
                          xchar:   (ch: char);//unicode
                          xstring: (pstr: pstring);// 32/64 Bit
              end;
     cellmem = array of mjcell;
     typemem = array of xtype;
     bitmem  = array of byte;
     charindex = array [byte] of cardinal;//???
     procmem = array [0..maxproc] of procedure;

var cell: cellmem;
    typeof: typemem;
    cebit: bitmem;
    cindex: charindex;
    proc: procmem;
    maxcell,freelist,identlist,cstack,efun,estack,x,y,z: cardinal;
    freeid: cardinal = xnil;
    idmark: cardinal = xnil;
    stack: cardinal = xnil;
    //idmonad: cardinal = xnil;
    iddef: cardinal = xnil;
    //idquote: cardinal = xnil;
    //idbottom: cardinal = xnil;
    quotenext: boolean = false;
    mjformatsettings: tformatsettings;

function cons(a,d: cardinal): cardinal;//prov
function newstring(s: string): cardinal;//prov
function newident(s: string;v: cardinal): cardinal;
function newint(x: int64): cardinal;
function newfloat(x: double): cardinal;//prov
function newchar(x: char): cardinal;
function newcharseq(s: string): cardinal;
function seqtostring(i: cardinal): string;
//procedure newexc(s: string);
procedure gc(a,d: cardinal);
procedure precom(var txt: string);
procedure postcom;
procedure run;
function tosequence(i: cardinal): string;
function tovalue(i: cardinal): string;
procedure xreversey;
procedure eval;
procedure initvm(mc: cardinal);
procedure finalvm;

implementation

uses servunit, primunit;

const //in Deutsch?
      egcerror = 'Garbage Collection: Recycling kann nicht durchgeführt werden. Abbruch!';
      ecellnotfree = 'Garbage Collection: Gesamter Cell-Speicher verbraucht. Abbruch!';
      enostringmemerror = 'Kein Speicherplatz mehr frei für Zeichenkette.';
      //
      enomemoryerror = 'Nicht genug Betriebsmittel für Cell-Speicher.';
      //
      ecomnocommentbegin = 'Compiler > Kein Kommentaranfang.';
      ecomnocommentend  = 'Compiler > Kommentar nicht abgeschlossen.';
      ecomnoprebracket  = 'Compiler > Text ohne Anfangsklammer.';
      ecomnopostbracket = 'Compiler > Frühzeitiges Ende des Textes. "]" fehlt.';
      ecomnostringend = 'Compiler > String nicht abgeschlossen.';//???
      ecomnoquote = 'Compiler > comnoquote > ''Abschließendes Quote (") fehlt.''';
      //'Termination quote is missing.';//engl?
      //
      ecomnoconstname = 'Compiler > Konstanten-Bezeichner fehlt.';
      ecomconstnoident = 'Compiler > Konstantenname muss Bezeichner sein.';
      ecomconsttaken = 'Compiler > Konstante ist bereits definiert';
      //
      eidentnull = 'Interpreter > Bezeichner ist nicht definiert';

//--------------------- Speicherverwaltung ----------------------

var freetop: cardinal;

procedure initfreelist;
var i: cardinal;
begin typeof[xnil]:=xnull;
      cebit[xnil]:=1;
      freelist:=xnil;
      for i:=maxcell downto 1 do begin
          typeof[i]:=xcons;
          with cell[i] do begin addr:=xnil; decr:=freelist end;
          freelist:=i;
          cebit[i]:=0
      end
end;

var objp: cardinal;

procedure traverse(i: cardinal);// kein onjump verwenden!
begin if (cebit[i]=0) then begin
         cebit[i]:=1;
         if (typeof[i]=xcons) then
            repeat objp:=cell[i].addr;
                   if (typeof[objp]=xcons) then traverse(objp)
                                           else cebit[objp]:=1;
                   i:=cell[i].decr;
                   if (cebit[i]=1) then exit;
                   cebit[i]:=1
            until false
      end
end;

procedure traverseidents;// kein onjump verwenden!
var i: cardinal;
begin i:=identlist;
      while (i<>xnil) do begin
            traverse(cell[cell[i].addr].pname);//schnellerer Code!
            traverse(cell[cell[i].addr].value);
            i:=cell[i].decr
      end
end;

procedure gc(a,d: cardinal);
var i,c: cardinal;
begin;//freelist,identlist,,,,,//
      try cebit[xnil]:=1;
          traverse(a);
          traverse(d);
          for c:=0 to 255 do cebit[cindex[c]]:=1;
          //
          traverse(freeid);
          traverse(cstack);
          traverse(stack);
          traverse(efun);
          traverse(estack);
          traverse(x);
          traverse(y);
          traverse(z);
          //
          traverse(trail);
          traverse(mstack);
          //
          traverse(identlist);
          traverseidents;
          freelist:=xnil;
          for i:=maxcell downto 1 do
              if (cebit[i]=0) then begin
                 if (typeof[i]=xstring) then dispose(cell[i].pstr);//wenn xstring ->pstr dann disposen
                 typeof[i]:=xcons;
                 with cell[i] do begin addr:=xnil; decr:=freelist end;
                 freelist:=i//
              end
              else cebit[i]:=0//;
      except //quitunit=?
             raise exception.create(egcerror)
             //
      end;
      if (freelist=xnil) then begin //quitunit=?
                                    raise exception.create(ecellnotfree)
                              end;
end;

function cons(a,d: cardinal): cardinal;
begin if (freelist=xnil) then gc(a,d);
      freetop:=freelist;
      freelist:=cell[freelist].decr;
      typeof[freetop]:=xcons;
      with cell[freetop] do begin addr:=a; decr:=d end;
      cons:=freetop
end;

function newstring(s: string): cardinal;
var ps: pstring;//global?
begin if (freelist=xnil) then gc(xnil,xnil);
      try new(ps);
          ps^:=s
      except//quitunit=...
             raise exception.create(enostringmemerror);////
      end;
      freetop:=freelist;
      freelist:=cell[freelist].decr;
      typeof[freetop]:=xstring;
      cell[freetop].pstr:=ps;
      newstring:=freetop
end;

function newident(s: string;v: cardinal): cardinal;
begin freeid:=newstring(s);
      if (freelist=xnil) then gc(xnil,v);
      freetop:=freelist;
      freelist:=cell[freelist].decr;
      typeof[freetop]:=xident;
      with cell[freetop] do begin pname:=freeid; value:=v end;
      freeid:=xnil;
      newident:=freetop;
      identlist:=cons(freetop,identlist)
end;

function newint(x: int64): cardinal;
begin if (freelist=xnil) then gc(xnil,xnil);
      freetop:=freelist;
      freelist:=cell[freelist].decr;
      typeof[freetop]:=xint;
      cell[freetop].inum:=x;
      newint:=freetop
end;

function newfloat(x: double): cardinal;
begin if (freelist=xnil) then gc(xnil,xnil);
      freetop:=freelist;
      freelist:=cell[freelist].decr;
      typeof[freetop]:=xfloat;
      cell[freetop].fnum:=x;
      newfloat:=freetop
end;

function newchar(x: char): cardinal;
begin if (freelist=xnil) then gc(xnil,xnil);
      freetop:=freelist;
      freelist:=cell[freelist].decr;
      typeof[freetop]:=xchar;
      cell[freetop].ch:=x;
      newchar:=freetop
end;

function newcharseq(s: string): cardinal;
var i: cardinal;
begin freeid:=xnil;
      for i:=length(s) downto 1 do
          if (s[i]<=#255) then freeid:=cons(cindex[ord(s[i])],freeid)
                          else freeid:=cons(newchar(s[i]),freeid);
      newcharseq:=freeid;
      freeid:=xnil
end;

{procedure newexc(s: string);
begin stack:=cons(newstring(s),stack);
      stack:=cons(idbottom,stack);
end;}

function seqtostring(i: cardinal): string;  //   i muss xcons sein!
var s: string; obj: cardinal;
begin s:='';
      //vllt auch für xident, xchar und xcons+xnull
      while (typeof[i]<>xnull) do begin
            obj:=cell[i].addr;
            if (typeof[obj]<>xchar) then break;
            s:=s+cell[obj].ch;
            i:=cell[i].decr
      end;
      seqtostring:=s
end;

//----------------------- List-to-Text Ausgabe ----------------------
//function tovalue(...   nein!
const mjformat = ffGeneral;
      maxdigits = 16;
      maxpdigits = 15;

function tofloat(num: double): string;
begin tofloat:=stringreplace(
               floattostrF(num,mjformat,maxdigits,maxpdigits,mjformatsettings),
               ',','.',[rfReplaceAll])
end;

//vergleichen!
function tostring(var i: cardinal): string;
var s: string; k,obj: cardinal;
begin s:='';
      k:=i;
      while (typeof[i]<>xnull) do begin//xnil
            obj:=cell[i].addr;
            if (typeof[obj]<>xchar) then break;
            s:=s+cell[obj].ch;
            k:=i;
            i:=cell[i].decr
      end;
      i:=k;
      tostring:=ansiquotedstr(s,'"')
      //
end;

var topobj: cardinal;

function tosequence(i: cardinal): string;
var s: string;
    sp: string;//[1];//gloabal deklarieren?
begin s:='';
      sp:='';
      while (typeof[i]=xcons) do begin
            topobj:=cell[i].addr;
            case typeof[topobj] of
                 xnull : s:=s + sp + '[]';
                 xident: s:=s + sp + cell[cell[topobj].pname].pstr^;
                 xint  : s:=s+sp+'('+inttostr(cell[topobj].inum)+')';
                 xfloat: s:=s + sp + tofloat(cell[topobj].fnum);
                 xcons : s:=s + sp + '['+tosequence(topobj)+']';
                 xchar : s:=s+sp+tostring(i);// i modifier;
                 xstring:s:=s + sp + '('+ansiquotedstr(cell[topobj].pstr^,'"')+')';
            else s:=s+sp+'(...)'
            end;
            sp:=' ';
            i:=cell[i].decr
      end;
      if (typeof[i]=xnull) then tosequence:=s //xnil
      else tosequence:='(...s)'
end;

//function tovalue(i: cardinal): string;
function tovalue(i: cardinal): string;
begin case typeof[i] of
           xnull : tovalue:='[]';
           xcons : tovalue:='['+tosequence(i)+']';
           xident: tovalue:=cell[cell[i].pname].pstr^;
           xint  : tovalue:='('+inttostr(cell[i].inum)+')';
           xfloat: tovalue:=tofloat(cell[i].fnum);
           xchar : tovalue:=ansiquotedstr(cell[i].ch,'"');
           xstring: tovalue:='('+ansiquotedstr(cell[i].pstr^,'"')+')';
      else tovalue:='(...v)'
      end
end;

//------------------------- Scanner --------------------------------

function item(var s: string;var i: longint): string; //longint?
// i entspricht selstart
var k: longint; //longint?
    quit: boolean;
    ch: string;
begin inc(i);
      ch:=copy(s,i,1);
      while ((length(ch)=1) and (ch[1]<=#32)) do begin
            inc(i);
            ch:=copy(s,i,1)
      end;
      k:=i;
      quit:=false;
      if (ch<>'') then begin
         if charinset(s[i],special) then inc(i)
         else repeat inc(i);
                     if (i>length(s)) then quit:=true
                     else quit:=(charinset(s[i],special) or (s[i]<=#32))
              until quit
      end;
      item:=copy(s,k,i-k);
      dec(i)
end;

//--------------------------- Precompiler ------------------------------

procedure nreverse(var n: cardinal);
var p,reseq: cardinal;
begin reseq:=xnil;
      while (n<>xnil) do begin
            p:=n;
            n:=cell[n].decr;
            cell[p].decr:=reseq;
            reseq:=p
      end;
      n:=reseq
end;

procedure precom(var txt: string);
var it: string;
    ix: longint;

    procedure precomraise(s: string);
    begin //textdump:=true;
          raise exception.create(s)
    end;

    procedure comment;
    begin repeat it:=item(txt,ix);//=    inc(ix);it:=copy(txt,ix,1)
                 if (it='') then precomraise(ecomnocommentend)//fpraise(iderrornocommentend,copy(txt,1,ix))
          until (it=')')
    end;

    procedure comstring;
    var k:longint;//???
    begin k:=ix;
          repeat inc(ix);
                 it:=copy(txt,ix,1);
                 if (it='') then precomraise(ecomnostringend);
                 if (it='"') then begin
                    if (copy(txt,ix+1,1)<>'"') then break;
                    inc(ix);
                 end;
          until false;
          it:=copy(txt,k,ix-k+1);
          cstack:=cons(newstring(AnsiDequotedStr(it,'"')),cstack)//
    end;

    procedure charsequence;
    begin repeat inc(ix);
                 it:=copy(txt,ix,1);
                 if (it='') then precomraise(ecomnoquote);
                 if (it='"') then begin
                    if (copy(txt,ix+1,1)<>'"') then break;
                    inc(ix);
                    cstack:=cons(cindex[ord('"')],cstack)
                 end
                 else if (it[1]<=#255) then
                         cstack:=cons(cindex[ord(it[1])],cstack)
                      else cstack:=cons(newchar(it[1]),cstack)
          until false
    end;

    function find(it: string): cardinal;
    var seq,found: cardinal;
    begin seq:=identlist;
          found:=xnil;
          while ((seq<>xnil) and (found=xnil)) do
                if (cell[cell[cell[seq].addr].pname].pstr^ = it) then
                   found:=cell[seq].addr
                else seq:=cell[seq].decr;
          find:=found
    end;

    function ident(it: string): cardinal;
    var id: cardinal;
    begin id:=find(it);
          if (id=xnil) then ident:=newident(it,xnil)
                       else ident:=id
    end;

    procedure atom(var it: string);
    var numstr: string;
        errcode: longint;
        num: double;
    begin numstr:=stringreplace(it,',','.',[rfReplaceAll]);
          val(numstr,num,errcode);
          if (numstr[1]='.')         then errcode:=1;
          if (copy(numstr,1,2)='-.') then errcode:=1;
          if (upcase(numstr[1])='E') then errcode:=1;
          if (errcode=0) then cstack:=cons(newfloat(num),cstack)
                         else cstack:=cons(ident(it),cstack)
    end;

    procedure cbackcons;
    var p,q: cardinal;
    begin p:=xnil;
          while (cell[cstack].addr<>idmark) do begin
                q:=cstack;
                cstack:=cell[cstack].decr;
                cell[q].decr:=p;
                p:=q
          end;
          cell[cstack].addr:=p
    end;

    procedure list;
    begin cstack:=cons(idmark,cstack);
          it:=item(txt,ix);
          while (it<>']') do begin
                if      (it='')  then precomraise(ecomnopostbracket)//fpraise(iderrornopostbracket,copy(txt,1,ix))
                else if (it='[') then list
                else if (it='(') then comment
                else if (it=')') then precomraise(ecomnocommentbegin)
                else if (it='"') then charsequence
                //else if (it='"') then comstring
                else atom(it);
                it:=item(txt,ix)
          end;
          cbackcons
    end;

//procedure precom; // fin? anpassung
begin ix:=0;
      cstack:=xnil;
      it:=item(txt,ix);
      while (it<>'') do begin
            if      (it='[') then list
            else if (it=']') then precomraise(ecomnoprebracket)//fpraise(iderrornoprebracket,copy(txt,1,ix))
            else if (it='(') then comment
            else if (it=')') then precomraise(ecomnocommentbegin)
            else if (it='"') then charsequence
            //else if (it='"') then comstring
            else atom(it);
            it:=item(txt,ix)
      end;
      nreverse(cstack);
end;

//------------------------- Postcompiler ------------------------

procedure postcomraise(s: string); // fin? anpassung
begin //cstack:=etop;
      nreverse(cstack);
      //etop:=
      //generror(s);
      //listdump:=true;
      raise exception.create(s)
end;

procedure postcom; // fin? anpassung             redef???
var tail,obj,p: cardinal;//???longint;
begin nreverse(cstack);
      tail:=xnil;
      while (cstack<>xnil) do begin
            obj:=cell[cstack].addr;
            if (obj=iddef) then begin
               cstack:=cell[cstack].decr;
               if (cstack=xnil) then postcomraise(ecomnoconstname);
               obj:=cell[cstack].addr;
               if (typeof[obj]<>xident) then postcomraise(ecomconstnoident);
               if (not(redef) and (cell[obj].value<>xnil)) then
                  postcomraise(ecomconsttaken+' - '+tovalue(obj));
               cell[obj].value:=tail;
               tail:=xnil;
               cstack:=cell[cstack].decr
            end
            else begin
               p:=cstack;
               cstack:=cell[cstack].decr;
               cell[p].decr:=tail;
               tail:=p;
            end
      end;
      cstack:=tail;
      tail:=xnil//???
end;

//----------------------- mjoy-interpreter ----------------------------
//
// interpreter for higher-order programming

procedure xreversey;//muss Liste sein!
begin y:=xnil;
      while (x<>xnil) do begin
            y:=cons(cell[x].addr,y);
            x:=cell[x].decr
      end;
      //x:=xnil
end;

var id: cardinal;

procedure eval;  //eval: efun erwartet eine liste...???
begin //liste interpretieren
      estack:=cons(efun,estack);
      try if ((efun=xnil) or (typeof[efun]=xcons)) then
          //efun:=cell[estack].addr;//???
          //hier:was anderes als liste abprüfen...
          while (efun<>xnil) do begin
                efun:=cell[efun].addr;
                if quotenext then begin quotenext:=false;
                                        stack:=cons(efun,stack)
                                  end
                else if (typeof[efun]<>xident) then stack:=cons(efun,stack)
                else begin
                   id:=efun;
                   efun:=cell[efun].value;
                   if (typeof[efun]=xint) then proc[cell[efun].inum]//grenzen abprüfen!
                   else if (efun<>xnil) then eval
                   else raise exception.create(eidentnull+' - '+tovalue(id))
                end;
                efun:=cell[cell[estack].addr].decr;
                cell[estack].addr:=efun
          end
          else if (typeof[efun]<>xident) then stack:=cons(efun,stack)
          else begin
             id:=efun;
             efun:=cell[efun].value;
             if (typeof[efun]=xint) then proc[cell[efun].inum]//grenzen abprüfen!
             else if (efun<>xnil) then eval
             else raise exception.create(eidentnull+' - '+tovalue(id))
             //
          end;//...
          estack:=cell[estack].decr
          //
          //;mjform.ioedit.lines.append('ok');
      except estack:=cell[estack].decr;
             raise
      end
end;

procedure run;
begin efun:=cstack;
      estack:=xnil;
      quotenext:=false;//?
      eval;
      //
end;

//------------------------ Initialisierung --------------------------

procedure initcindex;
var c: char;
begin for c:=#0 to #255 do cindex[ord(c)]:=newchar(c)
end;

procedure initvm(mc: cardinal);
begin //;
      maxcell:=mc;
      freelist:=xnil;
      identlist:=xnil;
      freeid:=xnil;
      idmark:=xnil;
      cstack:=xnil;
      stack:=xnil;
      efun:=xnil;
      estack:=xnil;
      x:=xnil;
      y:=xnil;
      z:=xnil;
      //idmonad:=xnil;
      iddef:=xnil;
      //idquote:=xnil;
      //idbottom:=xnil;
      trail:=xnil;
      mjformatsettings:=TFormatSettings.Create;//(Locale);
      try setlength(cell,maxcell+1);
          setlength(typeof,maxcell+1);
          setlength(cebit,maxcell+1)
      except //quitunit=...
             raise exception.create(enomemoryerror);//errorquit()//
      end;
      initfreelist;
      initcindex;
      initidentprimitives;
      //initidents;
      //initprimitives;
      //servprint('sizeof(mjcell)='+inttostr(sizeof(mjcell)))//sizeof(mjcell)
end;

procedure freepstrings;   //und pstrs aufsammeln wie in gc
var i: cardinal;
begin for i:=1 to maxcell do
          if (typeof[i]=xstring) then dispose(cell[i].pstr)//
end;

procedure finalvm;
begin freepstrings;//freeidentlist;//nach entsorgung (freeidentlist): identlist:=xnil   ^
      trail:=xnil;   //...
      cell:=nil;
      typeof:=nil;
      cebit:=nil;
      //idmonadxnil
end;

end. // (c) 2016.08 - 2020.07 Fpstefan
