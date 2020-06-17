unit servunit;

interface

uses System.SysUtils,//exception
     System.Classes,//tstringlist
     Vcl.StdCtrls,//tmemo
     Vcl.ExtCtrls,//tpaintbox
     Vcl.Forms,//tform //Vcl.Graphics;//TCanvas
     System.Types,//TPoint
     Vcl.Graphics;//clblack;

const servmaxcelldef=300000;
      servmincell  = 100000;//bitte passend einstellen
      prompt='      ';
      guiformheightsub=143;

const xnil = 0;//vmunit           //clWebGold = $00D7FF; clWebOrange = $00A5FF;

var guimemo: tmemo = nil;
    guipaintbox: tpaintbox = nil;
    guiform: tform = nil;
    inqueue: tstringlist = nil;
    redef: boolean = false;
    trail: cardinal = xnil;
    idpen: cardinal = xnil;
    idcolor: cardinal = xnil;
    idsize: cardinal = xnil;
    idbrush: cardinal = xnil;
    idcircle: cardinal = xnil;
    idrect: cardinal = xnil;
    //
    idtrue: cardinal = xnil;
    idfalse: cardinal = xnil;
    idmonad: cardinal = xnil;
    mstack: cardinal = xnil;
    onquit: boolean = false;
    servidledone: boolean = true;

procedure servdrawtrail;
function extractslashpath(s: string): string;
function extractslashname(s: string): string;
function selectline(txt: string; i: longint): string;
procedure servidentdump;
procedure servprintstack;
procedure tellserv(txt: string);
procedure servprint(txt: string);
procedure servtogglepaintbox;
procedure servstopm;
procedure servreaction;
procedure initserv(mc: cardinal;var memo: tmemo;paintbox: tpaintbox;form: tform);
procedure finalserv;

implementation

uses vmunit, primunit;

const eservprintexc = 'Print procedure not defined.';//engl.?
      //emonadnonum = 'Monad > Zahlenwert erwartet.';
      //emonadnofloat = 'Monad > Float erwartet.';
      //emonadrounderr = 'Monad > Rundungsfehler.';
      //emonadnotinrange = 'Monad > Zahlenwert außerhalb von Sprungtabelle.';
      //bitte in deutsch !!!
      eservdrawnopair = 'Paired arrangement in the list expected.';
      eservdrawxynofloat = 'For x,y two floats expected.';
      eservdrawpennological = 'For pen a logical operand expected.';
      eservdrawcolornofloat = 'For color a float as operand expected.';
      eservdrawsizenofloat = 'For size a float as operand expected.';
      eservdrawbrushnofloat = 'For brush a float as operand expected.';
      eservdrawcirclenofloat = 'For circle a float as operand expected.';
      eservdrawcirclematherror = 'Circle calculation error.';
      eservdrawcircledrawerror = 'Error occurred during drawing of circle.';
      eservdrawrectdrawerror = 'Error occurred during drawing of rect.';
      eservdrawprotocolerror = 'Error in the protocol.';
      eservdrawtrailexc = 'Graphic procedure not defined.';

//schneller (?)
function car(i: cardinal): cardinal;//??? hier aufführen?
begin if (typeof[i]=xcons) then car:=cell[i].addr
                           else car:=xnil
end;

function cdr(i: cardinal): cardinal;//??? hier aufführen?
begin if (typeof[i]=xcons) then cdr:=cell[i].decr
                           else cdr:=xnil
end;

procedure servdrawtrail;
var i,p,q: cardinal;
    mjpen: boolean;
    r: double;
    p1,p2: tpoint;
begin if (guipaintbox<>nil) then
      with guipaintbox.canvas do begin
           ;
           moveto(0,0);//x,y
           p1:=penpos;
           pen.color:=clblack;
           pen.width:=1;
           mjpen:=true;
           i:=trail;
           while (i<>xnil) do begin
              p:=car(i);
              i:=cdr(i);
              if (i=xnil) then raise exception.create(eservdrawnopair);
              q:=car(i);
              i:=cdr(i);
              if (typeof[p]=xfloat) then begin
                 if (typeof[q]<>xfloat) then raise exception.create(eservdrawxynofloat);
                 p1:=penpos;
                 if mjpen then lineto(round(cell[p].fnum),round(-cell[q].fnum))
                          else moveto(round(cell[p].fnum),round(-cell[q].fnum))
              end
              else if (p=idpen) then begin
                 if      (q=idtrue)  then mjpen:=true
                 else if (q=idfalse) then mjpen:=false
                 else raise exception.create(eservdrawpennological)
              end
              else if (p=idcolor) then begin
                 if (typeof[q]<>xfloat) then raise exception.create(eservdrawcolornofloat);
                 pen.color:=round(cell[q].fnum)//
              end
              else if (p=idsize) then begin
                 if (typeof[q]<>xfloat) then raise exception.create(eservdrawsizenofloat);
                 pen.width:=round(cell[q].fnum)//
              end
              else if (p=idbrush) then begin
                 if (typeof[q]<>xfloat) then raise exception.create(eservdrawbrushnofloat);
                 brush.color:=round(cell[q].fnum)//
              end
              else if (p=idcircle) then begin
                 if (typeof[q]<>xfloat) then raise exception.create(eservdrawcirclenofloat);
                 r:=cell[q].fnum;
                 try if mjpen then
                        ellipse(round(penpos.x-r),round(penpos.y-r),
                                round(penpos.x+r),round(penpos.y+r))
                 except on ematherror do
                           raise exception.create(eservdrawcirclematherror)
                        else raise exception.create(eservdrawcircledrawerror)
                 end
              end
              else if (p=idrect) then begin
                 if mjpen then
                    try p2:=penpos;
                        fillrect(rect(p1.x,p1.y,p2.x,p2.y));
                        moveto(p2.x,p2.y);
                        lineto(p2.x,p1.y);
                        lineto(p1.x,p1.y);
                        lineto(p1.x,p2.y);
                        lineto(p2.x,p2.y)//
                    except raise exception.create(eservdrawrectdrawerror)
                    end
              end
              else raise exception.create(eservdrawprotocolerror);
              //
           end
           //moveto(0,0);//lineto(200,200)//
      end
      else raise exception.create(eservdrawtrailexc)
end;

function extractslashpath(s: string): string;
var i: longint;//cardinal (?)
    found: boolean;
begin i:=length(s);
      found:=false;
      while ((i>0) and not(found)) do begin
            found:=((s[i]='\') or (s[i]='/') or (s[i]=':'));
            if not(found) then dec(i)
      end;
      extractslashpath:=copy(s,1,i)
end;

function extractslashname(s: string): string;
var i: longint;// cardinal (?)
    found: boolean;
begin i:=length(s);
      found:=false;
      while ((i>0) and not(found)) do begin
            found:=((s[i]='\') or (s[i]='/') or (s[i]=':'));
            if not(found) then dec(i)
      end;
      extractslashname:=copy(s,i+1,length(s)-i)
end;

function selectline(txt: string; i: longint): string;//longint?
var k: longint;//longint?
    quit: boolean;
begin k:=i+1;
      quit:=false;
      repeat if (i=0) then quit:=true
             else if (txt[i]=#10) then quit:=true
             else dec(i)
      until quit;
      quit:=false;
      repeat if (k>length(txt)) then quit:=true
             else if (txt[k]=#13) then quit:=true
             else inc(k)
      until quit;
      selectline:=copy(txt,i+1,k-i-1)
end;

//kopiert von FPXE11 und modif
procedure servidentdump;
var p,q,obj{,len}: cardinal;
    s,crlf: string;
begin //panelbar nullstring
      p:=identlist;
      s:='';
      crlf:='';
      while (p<>xnil) do begin
            obj:=cell[p].addr;
            q:=cell[obj].value;
            if (q=xnil) then s:=tovalue(obj)+crlf+s
            else if (typeof[q]=xint) then
                    s:=tovalue(obj)+' '+mjdef+' '+tovalue(q)+crlf+s
            else s:=tovalue(obj)+' '+mjdef+' '+tosequence(q)+crlf+s;
            crlf:=#13#10;
            p:=cell[p].decr//
      end;
      servprint(s);
      servprint(prompt)//bitte markieren!!!!!!!!!!!!!!!
      {with fpform.iomemo do begin
           len:=length(text);
           lines.append(s+#13#10+ioprompt);//+#9
           selstart:=len;
           sellength:=length(#13#10)+length(s)+length(#13#10+ioprompt)
      end//};
end;

procedure servprintstack;//löschen?
begin x:=stack;
      xreversey;
      if (y=xnil) then servprint('(null)')
      else servprint(tosequence(y));
      //servprint(tovalue(stack));
      servprint(prompt)
end;

procedure tellserv(txt: string);
begin inqueue.add(txt);
end;

procedure servprint(txt: string);//txt ist pointer
begin if (guimemo <> nil) then guimemo.lines.append(txt)
      else raise exception.create(eservprintexc);
end;

//var enum: longint;//int64
//    num: cardinal;

{procedure servmonad;
begin stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(emonadnonum);//???
      num:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[num]<>xfloat) then raise exception.create(emonadnofloat);//???
      try enum:=round(cell[num].fnum);
      except raise exception.create(emonadrounderr)//prov
      end;
      if ((enum>=0) and (enum<=maxproc)) then proc[enum]
      else raise exception.create(emonadnotinrange)
      //...
end;}

const emonadstacknull = 'monad > stacknull > '+estacknull;
      emonadtypenolist = 'monad > typenolist > "Liste für Folgefunktion erwartet."';
      emonadrounderror = 'monad > rounderror > "Fehler bei Rundung."';
      emdotstacknull = 'mdot > stacknull > '+estacknull;
      emprintstacknull = 'mprint > stacknull > '+estacknull;
      emshowgraphstacknull = 'mshowgraph > stacknull > '+estacknull;
      emonadnofunc = 'monad > nofunc > "Funktion nicht definiert."';
      emonadnocorrecttype = 'monad > nocorrecttype > "Monade erwartet korrekte Parameter."';
      emloadstringstacknull='mloadstring > stacknull > '+estacknull;
      emloadstringtypenolist='mloadstring > typenolist > "Liste für den Dateinamen erwartet."';
      emloadstringfilenotexists='Datei existiert nicht.';//? format?
      emloadstringloaderror='Datei kann nicht geladen werden.';//? format?
      emsavestringstacknull='msavestring > stacknull > '+estacknull;
      emsavestringtypenolist1='msavestring > typenolist > "Liste für den Dateinamen erwartet."';
      emsavestringtypenolist2='msavestring > typenolist > "Liste für den String erwartet."';
      emsavestringsaveerror = 'Datei kann nicht gespeichert werden.';

procedure mdot;
begin if (stack=xnil) then raise exception.create(emdotstacknull);
      servprint(tovalue(cell[stack].addr));//bitte kompackter? ,ok-Haken
      stack:=cell[stack].decr
end;

procedure mprint;
begin if (stack=xnil) then raise exception.create(emprintstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]=xcons) then servprint(tosequence(x))
                           else servprint(tovalue(x));//wie bei []?
      x:=xnil
end;

procedure mshowgraph;
begin if (stack=xnil) then raise exception.create(emshowgraphstacknull);
      trail:=cell[stack].addr;
      stack:=cell[stack].decr;
      if ((guipaintbox<>nil) and (guiform<>nil)) then begin
         if (guipaintbox.height=0) then
            guipaintbox.height:=guiform.height-guiformheightsub;//prov
         guipaintbox.repaint
      end//
end;

procedure servtogglepaintbox;
begin if ((guipaintbox<>nil) and (guiform<>nil)) then begin //and...
         if (guipaintbox.height=0) then
            guipaintbox.height:=guiform.height-guiformheightsub //prov
         else guipaintbox.height:=0;
         //guipaintbox.repaint;
         //etop:=iodict //guipaintbox.repaint      ,xnil???
      end
      else raise exception.create('Device ist nicht installiert...')//...
end;

procedure mloadstring;
var fname: string;
    slist: tstringlist;
begin if (stack=xnil) then raise exception.create(emloadstringstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((typeof[x]=xcons) or (x=xnil)) then
         raise exception.create(emloadstringtypenolist);
      fname:=seqtostring(x);
      //parampath...
      if not(fileexists(fname)) then
         raise exception.create('"'+fname+'" - '+emloadstringfilenotexists); //???
      slist:=tstringlist.Create;
      try slist.loadfromfile(fname);
      except slist.free;
             raise exception.create('"'+fname+'" - '+emloadstringloaderror); //???
      end;
      x:=newcharseq(slist.text);
      slist.free;
      //servprint('{'+fname+'}');
      stack:=cons(x,stack);
      x:=xnil
end;

procedure msavestring;
var fname,s: string;
    slist: tstringlist;
begin if (stack=xnil) then raise exception.create(emsavestringstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(emsavestringstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((typeof[x]=xcons) or (x=xnil)) then
         raise exception.create(emsavestringtypenolist1);
      if not((typeof[y]=xcons) or (y=xnil)) then
         raise exception.create(emsavestringtypenolist2);
      fname:=seqtostring(x);
      //parampath...
      s:=seqtostring(y);
      slist:=tstringlist.create;
      slist.text:=s;//??? exc...
      try slist.savetofile(fname);
      except slist.free;
             raise exception.create('"'+fname+'" - '+emsavestringsaveerror); //???
      end;
      slist.free;
      //servprint('{'+fname+'}');
      x:=xnil;
      y:=xnil
      //
end;

procedure servmonad;
var i: int64;
begin stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(emonadstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(emonadstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((y=xnil) or (typeof[y]=xcons)) then
         raise exception.create(emonadtypenolist);
      if (typeof[x]=xfloat) then begin
         try i:=round(cell[x].fnum)
         except raise exception.create(emonadrounderror)
         end;
         mstack:=cons(y,mstack);
         case i of
              1: mdot;
              2: mprint;
              3: mshowgraph;
              4: mloadstring;
              5: msavestring;
         else raise exception.create(emonadnofunc)
         end//
      end
      else if ((x=xnil) or (typeof[x]=xcons)) then begin
         mstack:=cons(y,mstack);
         efun:=x;
         eval//
      end
      else raise exception.create(emonadnocorrecttype);
      x:=xnil;
      y:=xnil;
      //eval//...
end;

procedure servstopm;
begin//...
mstack:=xnil
end;

procedure servreaction; // fundamental loop
var txt: string;
len:cardinal;
begin try onquit:=false;//richtig?
          if (stack<>xnil) then begin
             if (cell[stack].addr=idmonad) then begin servmonad;
                                                      servidledone:=false;
            { txt:=guimemo.text;
             len:=length(txt);
             txt:=selectline(txt,len);
             if (txt<>prompt) then servprint(prompt)
             else guimemo.selstart:=len;
             guimemo.setfocus }
                                                      ;
                                                      exit
                                                end
          end;
          if (mstack<>xnil) then begin efun:=cell[mstack].addr;
                                       mstack:=cell[mstack].decr;
                                       eval;
                                       servidledone:=false;
                                       exit
                                 end;
          if (inqueue.count>0) then begin
             txt:=inqueue.strings[0];//auf nils achten
             inqueue.delete(0);
             precom(txt);
             postcom;//redef???
             run;
             //servprint(tovalue(cstack));
             //
             //stack:=cons(newfloat(500),stack);
             //stack:=cons(idmonad,stack);
             //newexc('hallo welt');//
             //
             //servprint(inttostr($00A5FF));
             //if(typeof[cstack]=xcons)then servprint('--> '+tovalue(cell[cstack].addr));
             servidledone:=false;   //?
             exit
          end;
          if not(servidledone) then begin
             txt:=guimemo.text;
             len:=length(txt);
             txt:=selectline(txt,len);
             if (txt<>prompt) then servprint(prompt);
          {     if (txt = '') then begin
                guimemo.text:=guimemo.text+prompt;
             else guimemo.selstart:=len;
          // guimemo.setfocus
             end;}
          end;
          servidledone:=true;
          //
      except mstack:=xnil;//? ...
             raise// prov ,servprint prompt
      end
end;

procedure initserv(mc: cardinal;var memo: tmemo;paintbox: tpaintbox;form: tform);
begin onquit:=false;
      idmonad:=xnil;
      mstack:=xnil;
      inqueue:=tstringlist.create;
      servidledone:=true;
      //
      guimemo:=memo;
      guipaintbox:=paintbox;
      guiform:=form;
      //
      //trail:=...
      initvm(mc)
      ;idmonad:=newident('!',xnil);
      //
end;

procedure finalserv;
begin finalvm;
      idmonad:=xnil;//?
      inqueue.free;
      guimemo:=nil;
      guipaintbox:=nil;
      guiform:=nil;
      //
end;

end. // (c) 2016.08 - 2017 Stefan Cygon
