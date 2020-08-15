unit primunit;

interface

uses Windows,//RGB
     System.SysUtils,//exception
     System.Math;//power ,degtorad

type mjproc = procedure;
var pcounter: longint = 0;

//procedure initidents;
//procedure initprimitives;
procedure initidentprimitives;

const estacknull = '"Stack ist leer."';
      //emonadstacknull = 'monad > stacknull > '+estacknull;

implementation

uses vmunit, servunit;

const efuncundef = 'eval > funcundef > "Funktion ist nicht definiert."';
      //efundef = 'undef > funcundef > ''Funktion ist nicht definiert.''';
      etypenofloat='"Typ ist kein Float."';
      efloatexpected='"Fließkommazahl erwartet."';
      //edotstacknull = '. > stacknull > '+estacknull;//???
      eunstackstacknull = 'unstack > stacknull > '+estacknull;
      eunstacktypenolist = 'unstack > typenolist > "Typ ist keine Liste."';
      edupstacknull = 'dup > stacknull > '+estacknull;//???
      epopstacknull = 'pop > stacknull > '+estacknull;//???
      eswapstacknull = 'swap > stacknull > '+estacknull;//???
      eoverstacknull = 'over > stacknull > '+estacknull;
      efirststacknull = 'first > stacknull > '+estacknull;
      //efirsttypenocons = 'first > typenocons > ''Typ ist nicht cons.''';
      ereststacknull = 'rest > stacknull > '+estacknull;
      econsstacknull = 'cons > stacknull > '+estacknull;
      econstypenolist = 'cons > typenolist > "Typ ist keine Liste."';
      eunconsstacknull = 'uncons > stacknull > '+estacknull;
      eunconstypenocons = 'uncons > typenocons > "Typ ist keine Cons-Zelle."';
      eswonsstacknull = 'swons > stacknull > '+estacknull;
      eswonstypenolist = 'swons > typenolist > "Typ ist keine Liste."';
      eunswonsstacknull = 'unswons > stacknull > '+estacknull;
      eunswonstypenocons = 'unswons > typenocons > "Typ ist keine Cons-Zelle."';
      //
      eaddstacknull = '+ > stacknull > '+estacknull;
      eaddtypenofloat = '+ > typenofloat > '+etypenofloat;
      esubstacknull = '- > stacknull > '+estacknull;
      esubtypenofloat = '- > typenofloat > '+etypenofloat;
      emulstacknull = '* > stacknull > '+estacknull;
      emultypenofloat = '* > typenofloat > '+etypenofloat;
      edivstacknull = '/ > stacknull > '+estacknull;
      edivtypenofloat = '/ > typenofloat > '+etypenofloat;
      epowstacknull = 'pow > stacknull > '+estacknull;
      epowtypenofloat = 'pow > typenofloat > "Fließkommazahl erwartet."';
      //
      etypestacknull = 'type > stacknull > '+estacknull;//???
      eintstacknull = 'int > stacknull > '+estacknull;
      einttypenofloat = 'int > typenofloat > "Fließkommazahl erwartet."';
      epredstacknull = 'pred > stacknull > '+estacknull;
      epredtypenonum = 'pred > typenonum > "Float oder Char erwartet."';//???
      esuccstacknull = 'succ > stacknull > '+estacknull;
      esucctypenonum = 'succ > typenonum > "Float oder Char erwartet."';//???
      esignstacknull = 'sign > stacknull > '+estacknull;
      esigntypenofloat = 'sign > typenofloat > "Fließkommazahl erwartet."';
      eabsstacknull='abs > stacknull > '+estacknull;
      eabstypenofloat='abs > typenofloat > "Fließkommazahl erwartet."';
      enegstacknull = 'neg > stacknull > '+estacknull;
      enegtypenofloat = 'neg > typenofloat > "Fließkommazahl erwartet."';
      eroundstacknull = 'round > stacknull > '+estacknull;
      eroundtypenofloat = 'round > typenofloat > "Fließkommazahl erwartet."';
      eexpstacknull = 'exp > stacknull > '+estacknull;
      eexptypenofloat='exp > typenofloat > "Fließkommazahl erwartet."';
      elogstacknull='log > stacknull > '+estacknull;
      elogtypenofloat = 'log > typenofloat > "Fließkommazahl erwartet."';
      elog10stacknull = 'log10 > stacknull > '+estacknull;
      elog10typenofloat = 'log10 > typenofloat > "Fließkommazahl erwartet."';
      elog2stacknull = 'log2 > stacknull > '+estacknull;
      elog2typenofloat = 'log2 > typenofloat > "Fließkommazahl erwartet."';
      //
      eequalstacknull = '= > stacknull > '+estacknull;
      eltstacknull = '< > stacknull > '+estacknull;
      elttypenocomp = '< > typenocomp > "Typen sind nicht zu vergleichen."';//???
      elttypenochar='< > typenostring > "Typ ist kein String."';//???
      enotstacknull = 'not > stacknull > '+estacknull;
      enottypenobool = 'not > typenobool > "Typ ist kein logischer Wert."';
      eandstacknull = 'and > stacknull > '+estacknull;
      eandtypenobool = 'and > typenobool > "Typ ist kein logischer Wert."';
      eorstacknull = 'or > stacknull > '+estacknull;
      eortypenobool = 'or > typenobool > "Typ ist kein logischer Wert."';
      exorstacknull = 'xor > stacknull > '+estacknull;
      exortypenobool = 'xor > typenobool > "Typ ist kein logischer Wert."';
      enullstacknull='null > stacknull > '+estacknull;
      eliststacknull='list > stacknull > '+estacknull;
      elogicalstacknull='logical > stacknull > '+estacknull;
      econspstacknull='consp > stacknull > '+estacknull;
      eidentstacknull='ident > stacknull > '+estacknull;
      efloatstacknull='float > stacknull > '+estacknull;
      echarstacknull='char > stacknull > '+estacknull;
      eundefstacknull='undef > stacknull > '+estacknull;
      enamestacknull='name > stacknull > '+estacknull;
      enametypenoident='name > typenoident > "Typ ist kein Ident."';
      ebodystacknull='body > stacknull > '+estacknull;
      ebodytypenoident='body > typenoident > "Typ ist kein Ident."';
      euserstacknull = 'user > stacknull > '+estacknull;
      eusertypenoident = 'user > typenoident > "Typ ist kein Ident."';
      eaddrstacknull = 'addr > stacknull > '+estacknull;
      //
      //eshowgraphstacknull='showgraph > stacknull > '+estacknull;
      //
      eistacknull = 'i > stacknull > '+estacknull;
      edipstacknull = 'dip > stacknull > '+estacknull;
      eifstacknull = 'if > stacknull > '+estacknull;
      eiftypenobool = 'if > typenobool > "Typ ist kein logischer Wert."';
      ebranchstacknull = 'branch > stacknull > '+estacknull;
      ebranchtypenobool = 'branch > typenobool > "Typ ist kein logischer Wert."';
      echoicestacknull = 'choice > stacknull > '+estacknull;
      echoicetypenobool = 'choice > typenobool > "Typ ist kein logischer Wert."';
      eselectstacknull='select > stacknull > '+estacknull;
      eselecttypenolist='select > typenolist > "Typ ist keine Liste."';
      eselectnocons='select > typenocons > "Typ ist keine Cons-Zelle."';//???
      econdstacknull='cond > stacknull > '+estacknull;
      econdtypenolist='cond > typenolist > "Typ ist keine Liste."';
      econdnocons='cond > typenocons > "Typ ist keine Cons-Zelle."';//???
      econdnobool='cond > typenobool > "Typ ist kein logischer Wert."';
      etrystacknull = 'try > stacknull > '+estacknull;
      estepstacknull = 'step > stacknull > '+estacknull;
      esteptypenolist='step > typenolist > "Typ ist keine Liste."';//
      erollupstacknull = 'rollup > stacknull > '+estacknull;
      erolldownstacknull = 'rolldown > stacknull > '+estacknull;
      erotatestacknull = 'rotate > stacknull > '+estacknull;
      //
      etimesstacknull = 'times > stacknull > '+estacknull;
      ewhilestacknull = 'while > stacknull > '+estacknull;
      ewhilestacknullforbool='while > stacknullforbool > "Kein logischer Wert im Stack."';//???
      ewhiletypenobool='while > typenobool > "Typ ist kein logischer Wert."';
      //
      eindexstacknull = 'index > stacknull > '+estacknull;
      eindextypenofloat='index > typenofloat > "Fließkommazahl erwartet."';
      eindexrounderror='index > rounderror > "Rundungfehler."';
      eindexoutofrange='index > outofrange > "Zugriff außerhalb des Stacks."';
      //
      //eprintstacknull = 'print > stacknull > '+estacknull;
      //
      ereversestacknull = 'reverse > stacknull > '+estacknull;
      ereversetypenolist = 'reverse > typenolist > "Typ ist keine Liste."';
      esizestacknull = 'size > stacknull > '+estacknull;
      esizetypenolist = 'size > typenolist > "Typ ist keine Liste."';
      etakestacknull='take > stacknull > '+estacknull;
      etaketypenolist='take > typenolist > "Typ ist keine Liste."';
      etaketypenofloat='take > typenofloat > "Fließkommazahl erwartet."';
      etakerounderror='take > rounderror > "Rundungsfehler."';
      edropstacknull='drop > stacknull > '+estacknull;
      edroptypenolist='drop > typenolist > "Typ ist keine Liste."';
      edroptypenofloat='drop > typenofloat > "Fließkommazahl erwartet."';
      edroprounderror='drop > rounderror > "Rundungsfehler."';
      econcatstacknull='concat > stacknull > '+estacknull;
      econcattypenolist='concat > typenolist > "Typ ist keine Liste."';
      eswoncatstacknull = 'swoncat > stacknull > '+estacknull;
      eswoncattypenolist = 'swoncat > typenolist > "Typ ist keine Liste."';
      egetstacknull='get > stacknull > '+estacknull;
      egettypenolist='get > typenolist > "Typ ist keine Liste."';
      egettypenoident='get > typenoident > "Typ ist kein Bezeichner."';
      egetkeynovalue='get > keynovalue > "Zum Key fehlt der Value."';//???
      eputstacknull='put > stacknull > '+estacknull;
      eputtypenolist='put > typenolist > "Typ ist keine Liste."';
      eputtypenoident='put > typenoident > "Typ ist kein Bezeichner."';
      eputkeynovalue='put > keynovalue > "Zum Key fehlt der Value."';//???
      //;
      eiotastacknull = 'iota > stacknull > '+estacknull;
      eiotatypenofloat = 'iota > typenofloat > "Fließkommazahl erwartet."';
      eiotarounderror = 'iota > rounderror > "Rundungsfehler."';
      eradstacknull = 'rad > stacknull > '+estacknull;
      eradtypenofloat = 'rad > typenofloat > '+efloatexpected;
      edegstacknull = 'deg > stacknull > '+estacknull;
      edegtypenofloat = 'deg > typenofloat > '+efloatexpected;
      //
      esinstacknull = 'sin > stacknull > '+estacknull;
      esintypenofloat = 'sin > typenofloat > "Fließkommazahl erwartet."';
      ecosstacknull = 'cos > stacknull > '+estacknull;
      ecostypenofloat = 'cos > typenofloat > "Fließkommazahl erwartet."';
      etanstacknull = 'tan > stacknull > '+estacknull;
      etantypenofloat = 'tan > typenofloat > "Fließkommazahl erwartet."';
      easinstacknull = 'asin > stacknull > '+estacknull;
      easintypenofloat = 'asin > typenofloat > "Fließkommazahl erwartet."';
      eacosstacknull = 'acos > stacknull > '+estacknull;
      eacostypenofloat = 'acos > typenofloat > '+efloatexpected;
      eatanstacknull = 'atan > stacknull > '+estacknull;
      eatantypenofloat = 'atan > typenofloat > '+efloatexpected;
      eatan2stacknull = 'atan2 > stacknull > '+estacknull;
      eatan2typenofloat = 'atan2 > typenofloat > "Fließkommazahl erwartet."';
      esinhstacknull = 'sinh > stacknull > '+estacknull;
      esinhtypenofloat = 'sinh > typenofloat > "Fließkommazahl erwartet."';
      ecoshstacknull = 'cosh > stacknull > '+estacknull;
      ecoshtypenofloat = 'cosh > typenofloat > "Fließkommazahl erwartet."';
      etanhstacknull = 'tanh > stacknull > '+estacknull;
      etanhtypenofloat = 'tanh > typenofloat > "Fließkommazahl erwartet."';
      esqrtstacknull='sqrt > stacknull > '+estacknull;
      esqrttypenofloat='sqrt > typenofloat > "Fließkommazahl erwartet."';
      //
      eupperstacknull='upper > stacknull > '+estacknull;
      euppertypenochar='upper > typenochar > "Char erwartet."';
      elowerstacknull='lower > stacknull > '+estacknull;
      elowertypenochar='lower > typenochar > "Char erwartet."';
      echrstacknull='chr > stacknull > '+estacknull;
      echrtypenofloat='chr > typenofloat > '+efloatexpected;
      echroutofrange='chr > outofrange > "Wert außerhalb des Unicode-Bereiches."';
      eordstacknull='ord > stacknull > '+estacknull;
      eordtypenochar='ord > typenochar > "Char erwartet."';
      eminstacknull = 'min > stacknull > '+estacknull;
      emintypenocomp = 'min > typenocomp > "Typen sind nicht zu vergleichen."';//???
      emaxstacknull = 'max > stacknull > '+estacknull;
      emaxtypenocomp = 'max > typenocomp > "Typen sind nicht zu vergleichen."';//???
      //
      ergbstacknull = 'rgb > stacknull > '+estacknull;
      ergbtypenofloat='rgb > typenofloat > '+etypenofloat;
      //seiteneffekt:
      eoutstacknull='out > stacknull > '+estacknull;
      eparsestacknull='parse > stacknull > '+estacknull;
      eparsetypenolist='parse > typenolist > "Typ ist keine Liste."';
      etostrstacknull = 'tostr > stacknull > '+estacknull;
      eerrorstacknull = 'error > stacknull > '+estacknull;

var idundef: cardinal = xnil;
    //idtrue: cardinal = xnil;
    //idfalse: cardinal = xnil;
    idnull: cardinal = xnil;
    idcons: cardinal = xnil;
    idident: cardinal = xnil;
    idinteger: cardinal = xnil;
    idfloat: cardinal = xnil;
    idchar: cardinal = xnil;
    idstring: cardinal = xnil;

//------------------------------ Primitives ------------------------------------

procedure fundefined;    //fundef
begin raise exception.create(efuncundef)
end;

procedure fid;
begin //
end;

procedure fquote;
begin quotenext:=true
end;

procedure fstack;
begin stack:=cons(stack,stack)
end;

{procedure fclear;//unstack
begin stack:=xnil
end;}

procedure funstack;
begin if (stack=xnil) then raise exception.create(eunstackstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((x=xnil) or (typeof[x]=xcons)) then
         raise exception.create(eunstacktypenolist);
      stack:=x;
      x:=xnil
      //stack:=cell[stack].addr;???
end;

procedure fdup;
begin if (stack=xnil) then raise exception.create(edupstacknull);
      stack:=cons(cell[stack].addr,stack)
end;

procedure fpop;
begin if (stack=xnil) then raise exception.create(epopstacknull);
      stack:=cell[stack].decr
end;

procedure fswap;
begin if (stack=xnil) then raise exception.create(eswapstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eswapstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      stack:=cons(x,cons(y,stack));
      x:=xnil;
      y:=xnil
end;

procedure fover;
begin if (stack=xnil) then raise exception.create(eoverstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eoverstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      stack:=cons(x,cons(y,cons(x,stack)));
      x:=xnil;
      y:=xnil
end;

procedure ffirst;
begin if (stack=xnil) then raise exception.create(efirststacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;//kompakter?
      if (typeof[x]=xcons) then stack:=cons(cell[x].addr,stack)
                           else stack:=cons(xnil,stack);//raise exception.create(efirsttypenocons);
      x:=xnil
      //
end;

procedure frest;
begin if (stack=xnil) then raise exception.create(ereststacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;//kompakter?
      if (typeof[x]=xcons) then stack:=cons(cell[x].decr,stack)
                           else stack:=cons(xnil,stack);//raise exception.create(efirsttypenocons);
      x:=xnil
      //
end;

procedure fcons;
begin if (stack=xnil) then raise exception.create(econsstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(econsstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if ((typeof[y]=xcons) or (y=xnil)) then stack:=cons(cons(x,y),stack)
      else raise exception.create(econstypenolist);
      x:=xnil;
      y:=xnil
      //
end;

procedure fswons;
begin if (stack=xnil) then raise exception.create(eswonsstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eswonsstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if ((typeof[y]=xcons) or (y=xnil)) then stack:=cons(cons(x,y),stack)
      else raise exception.create(eswonstypenolist);
      x:=xnil;
      y:=xnil
end;

procedure funcons;
begin if (stack=xnil) then raise exception.create(eunconsstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xcons) then raise exception.create(eunconstypenocons);
      stack:=cons(cell[x].decr,cons(cell[x].addr,stack));
      x:=xnil
end;

procedure funswons;
begin if (stack=xnil) then raise exception.create(eunswonsstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xcons) then raise exception.create(eunswonstypenocons);
      stack:=cons(cell[x].addr,cons(cell[x].decr,stack));
      x:=xnil
end;

procedure fadd;
begin if (stack=xnil) then raise exception.create(eaddstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eaddstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(eaddtypenofloat);
      if (typeof[y]<>xfloat) then raise exception.create(eaddtypenofloat);
      z:=newfloat(cell[x].fnum + cell[y].fnum);
      stack:=cons(z,stack);
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure fsub;
begin if (stack=xnil) then raise exception.create(esubstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(esubstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(esubtypenofloat);
      if (typeof[y]<>xfloat) then raise exception.create(esubtypenofloat);
      z:=newfloat(cell[x].fnum - cell[y].fnum);
      stack:=cons(z,stack);
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure fmul;
begin if (stack=xnil) then raise exception.create(emulstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(emulstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(emultypenofloat);
      if (typeof[y]<>xfloat) then raise exception.create(emultypenofloat);
      z:=newfloat(cell[x].fnum * cell[y].fnum);//try?   ***hier***
      stack:=cons(z,stack);
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure fdiv;
begin if (stack=xnil) then raise exception.create(edivstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(edivstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(edivtypenofloat);
      if (typeof[y]<>xfloat) then raise exception.create(edivtypenofloat);
      z:=newfloat(cell[x].fnum / cell[y].fnum);//try?   ***hier***
      stack:=cons(z,stack);
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure fpow;
begin if (stack=xnil) then raise exception.create(epowstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(epowstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(epowtypenofloat);
      if (typeof[y]<>xfloat) then raise exception.create(epowtypenofloat);
      z:=newfloat(power(cell[x].fnum,cell[y].fnum));//try?   ***hier***
      stack:=cons(z,stack);
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure fint;
begin if (stack=xnil) then raise exception.create(eintstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(einttypenofloat);
      stack:=cons(newfloat(int(cell[x].fnum)),stack);//try?
      x:=xnil
end;

procedure fround;
begin if (stack=xnil) then raise exception.create(eroundstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(eroundtypenofloat);
      stack:=cons(newfloat(round(cell[x].fnum)),stack);//try?
      x:=xnil
end;

procedure fexp;
begin if (stack=xnil) then raise exception.create(eexpstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(eexptypenofloat);
      stack:=cons(newfloat(exp(cell[x].fnum)),stack);//try?
      x:=xnil
end;

procedure flog;
begin if (stack=xnil) then raise exception.create(elogstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(elogtypenofloat);
      stack:=cons(newfloat(ln(cell[x].fnum)),stack);//try?
      x:=xnil
end;

procedure flog10;
begin if (stack=xnil) then raise exception.create(elog10stacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(elog10typenofloat);
      stack:=cons(newfloat(log10(cell[x].fnum)),stack);//try?
      x:=xnil
end;

procedure flog2;
begin if (stack=xnil) then raise exception.create(elog2stacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(elog2typenofloat);
      stack:=cons(newfloat(log2(cell[x].fnum)),stack);//try?
      x:=xnil
end;

procedure fsign;
begin if (stack=xnil) then raise exception.create(esignstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(esigntypenofloat);
      stack:=cons(newfloat(sign(cell[x].fnum)),stack);//try?
      x:=xnil
end;

procedure fabs;
begin if (stack=xnil) then raise exception.create(eabsstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(eabstypenofloat);
      stack:=cons(newfloat(abs(cell[x].fnum)),stack);//try?
      x:=xnil
end;

procedure fneg;
begin if (stack=xnil) then raise exception.create(enegstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(enegtypenofloat);
      stack:=cons(newfloat(-cell[x].fnum),stack);//try?
      x:=xnil
end;

procedure ftrue;
begin stack:=cons(idtrue,stack)
end;

procedure ffalse;
begin stack:=cons(idfalse,stack)
end;

function equal(i,k: cardinal): boolean;
begin case typeof[i] of
           xnull : equal:=(k=xnil);
           xident: equal:=(i = k);
           xint  : equal:=false;//undef //prov
           xfloat: if (typeof[k]<>xfloat) then equal:=false
                   else equal:=(cell[i].fnum = cell[k].fnum);
           xchar : if (typeof[k]<>xchar) then equal:=false
                   else equal:=(cell[i].ch = cell[k].ch);
           xcons : if (typeof[k]<>xcons) then equal:=false
                   else begin
                      while ((i<>xnil) and (k<>xnil)) do begin
                         if not(equal(cell[i].addr,cell[k].addr)) then begin
                            equal:=false;
                            exit
                         end;
                         i:=cell[i].decr;
                         k:=cell[k].decr
                      end;
                      equal:=((i=xnil) and (k=xnil))
                   end;
           xstring: equal:=false;//undef //prov
      else equal:=false//undef //prov
      end
end;

procedure feq;
begin if (stack=xnil) then raise exception.create(eequalstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eequalstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if equal(x,y) then stack:=cons(idtrue,stack)
                    else stack:=cons(idfalse,stack);
      //stack:=cons(z,stack);
      x:=xnil;
      y:=xnil;
      //z:=xnil
end;

{ stringlt==((isnil°1)->(not°isnil°2);(isnil°2)->(f&);(1°1)<1°2)
	°((isnil°1)->(f&);(isnil°2)->(f&);(1°1)=1°2)->*(tail°1)@tail°2 }

function less(i,k: cardinal): boolean;
var p,q: cardinal;
begin while ((i<>xnil) and (k<>xnil)) do begin
         p:=cell[i].addr;
         q:=cell[k].addr;
         if not((typeof[p]=xchar) and (typeof[q]=xchar)) then
            raise exception.create(elttypenochar);   //eltlistnochar?
         if (cell[p].ch < cell[q].ch) then begin less:=true; exit end;
         if (cell[p].ch > cell[q].ch) then begin less:=false; exit end;
         i:=cell[i].decr;
         k:=cell[k].decr
      end;
      if ((i=xnil) and (k=xnil)) then less:=false
      else less:=(i=xnil)
end;

procedure flt;
begin if (stack=xnil) then raise exception.create(eltstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eltstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      case typeof[x] of
           xnull : if not((typeof[y]=xcons) or (y=xnil)) then
                      raise exception.create(elttypenocomp)
                   else if less(x,y) then z:=idtrue
                                     else z:=idfalse;
           xident: if (typeof[y]<>xident) then raise exception.create(elttypenocomp)
                   else if (cell[cell[x].pname].pstr^ < cell[cell[y].pname].pstr^)
                        then z:=idtrue
                        else z:=idfalse;
           xint  : z:=idundef;//prov
           xfloat: if (typeof[y]<>xfloat) then raise exception.create(elttypenocomp)
                   else if (cell[x].fnum < cell[y].fnum) then z:=idtrue
                                                         else z:=idfalse;
           xchar : if (typeof[y]<>xchar) then raise exception.create(elttypenocomp)
                   else if (cell[x].ch < cell[y].ch) then z:=idtrue
                                                     else z:=idfalse;
           xcons : if not((typeof[y]=xcons) or (y=xnil)) then
                      raise exception.create(elttypenocomp)
                   else if less(x,y) then z:=idtrue
                                     else z:=idfalse;//idundef;//prov
      else z:=idundef//prov
      end;
      stack:=cons(z,stack);
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure fmin;
begin if (stack=xnil) then raise exception.create(eminstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eminstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      case typeof[x] of
           xnull : if not((typeof[y]=xcons) or (y=xnil)) then
                      raise exception.create(emintypenocomp)
                   else if less(x,y) then z:=x
                                     else z:=y;
           xident: if (typeof[y]<>xident) then raise exception.create(emintypenocomp)
                   else if (cell[cell[x].pname].pstr^ < cell[cell[y].pname].pstr^)
                        then z:=x
                        else z:=y;
           xint  : z:=idundef;//prov
           xfloat: if (typeof[y]<>xfloat) then raise exception.create(emintypenocomp)
                   else if (cell[x].fnum < cell[y].fnum) then z:=x
                                                         else z:=y;
           xchar : if (typeof[y]<>xchar) then raise exception.create(emintypenocomp)
                   else if (cell[x].ch < cell[y].ch) then z:=x
                                                     else z:=y;
           xcons : if not((typeof[y]=xcons) or (y=xnil)) then
                      raise exception.create(emintypenocomp)
                   else if less(x,y) then z:=x
                                     else z:=y;//idundef;//prov
      else z:=idundef//prov
      end;
      stack:=cons(z,stack);
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure fmax;
begin if (stack=xnil) then raise exception.create(emaxstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(emaxstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      case typeof[x] of
           xnull : if not((typeof[y]=xcons) or (y=xnil)) then
                      raise exception.create(emaxtypenocomp)
                   else if less(x,y) then z:=y
                                     else z:=x;
           xident: if (typeof[y]<>xident) then raise exception.create(emaxtypenocomp)
                   else if (cell[cell[x].pname].pstr^ < cell[cell[y].pname].pstr^)
                        then z:=y
                        else z:=x;
           xint  : z:=idundef;//prov
           xfloat: if (typeof[y]<>xfloat) then raise exception.create(emaxtypenocomp)
                   else if (cell[x].fnum < cell[y].fnum) then z:=y
                                                         else z:=x;
           xchar : if (typeof[y]<>xchar) then raise exception.create(emaxtypenocomp)
                   else if (cell[x].ch < cell[y].ch) then z:=y
                                                     else z:=x;
           xcons : if not((typeof[y]=xcons) or (y=xnil)) then
                      raise exception.create(emaxtypenocomp)
                   else if less(x,y) then z:=y
                                     else z:=x;//idundef;//prov
      else z:=idundef//prov
      end;
      stack:=cons(z,stack);
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure fnot;
begin if (stack=xnil) then raise exception.create(enotstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if      (x=idtrue)  then stack:=cons(idfalse,stack)
      else if (x=idfalse) then stack:=cons(idtrue,stack)
      else raise exception.create(enottypenobool);
      x:=xnil
end;

procedure fand;
begin if (stack=xnil) then raise exception.create(eandstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eandstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (x=idtrue) then begin
         if      (y=idtrue)  then stack:=cons(idtrue,stack)
         else if (y=idfalse) then stack:=cons(idfalse,stack)
         else raise exception.create(eandtypenobool)
      end
      else if (x=idfalse) then begin
         if ((y=idtrue) or (y=idfalse)) then stack:=cons(idfalse,stack)
         else raise exception.create(eandtypenobool)
      end
      else raise exception.create(eandtypenobool);
      x:=xnil;
      y:=xnil
end;

procedure f_or;
begin if (stack=xnil) then raise exception.create(eorstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eorstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (x=idtrue) then begin
         if ((y=idtrue) or (y=idfalse)) then stack:=cons(idtrue,stack)
         else raise exception.create(eortypenobool)
      end
      else if (x=idfalse) then begin
         if      (y=idtrue)  then stack:=cons(idtrue,stack)
         else if (y=idfalse) then stack:=cons(idfalse,stack)
         else raise exception.create(eortypenobool)
      end
      else raise exception.create(eortypenobool);
      x:=xnil;
      y:=xnil
end;

procedure fxor;
begin if (stack=xnil) then raise exception.create(exorstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(exorstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if      (x=idtrue)  then begin
         if      (y=idtrue)  then stack:=cons(idfalse,stack)
         else if (y=idfalse) then stack:=cons(idtrue,stack)
         else raise exception.create(exortypenobool)
      end
      else if (x=idfalse) then begin
         if      (y=idtrue)  then stack:=cons(idtrue,stack)
         else if (y=idfalse) then stack:=cons(idfalse,stack)
         else raise exception.create(exortypenobool)
      end
      else raise exception.create(exortypenobool);
      x:=xnil;
      y:=xnil
end;

procedure fnull;
begin if (stack=xnil) then raise exception.create(enullstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if      (typeof[x]=xnull) then stack:=cons(idtrue,stack)
      else if (typeof[x]<>xfloat) then stack:=cons(idfalse,stack)
      else if (cell[x].fnum=0) then stack:=cons(idtrue,stack)
                               else stack:=cons(idfalse,stack);
      x:=xnil
end;

procedure flist;
begin if (stack=xnil) then raise exception.create(eliststacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if ((typeof[x]=xnull) or (typeof[x]=xcons)) then stack:=cons(idtrue,stack)
                                                  else stack:=cons(idfalse,stack);
      x:=xnil
end;

procedure flogical;
begin if (stack=xnil) then raise exception.create(elogicalstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if ((x=idtrue) or (x=idfalse)) then stack:=cons(idtrue,stack)
                                     else stack:=cons(idfalse,stack);
      x:=xnil
end;

procedure fconsp;
begin if (stack=xnil) then raise exception.create(econspstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]=xcons) then stack:=cons(idtrue,stack)
                           else stack:=cons(idfalse,stack);
      x:=xnil
end;

procedure fident;
begin if (stack=xnil) then raise exception.create(eidentstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]=xident) then stack:=cons(idtrue,stack)
                            else stack:=cons(idfalse,stack);
      x:=xnil
end;

procedure ffloat;
begin if (stack=xnil) then raise exception.create(efloatstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]=xfloat) then stack:=cons(idtrue,stack)
                            else stack:=cons(idfalse,stack);
      x:=xnil
end;

procedure fchar;
begin if (stack=xnil) then raise exception.create(echarstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]=xchar) then stack:=cons(idtrue,stack)
                           else stack:=cons(idfalse,stack);
      x:=xnil
end;

procedure fundef;
begin if (stack=xnil) then raise exception.create(eundefstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (x=idundef) then stack:=cons(idtrue,stack)
                     else stack:=cons(idfalse,stack);
      x:=xnil
end;

procedure ftype;
begin if (stack=xnil) then raise exception.create(etypestacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      case typeof[x] of
           xnull:   z:=idnull;
           xcons:   z:=idcons;
           xident:  z:=idident;
           xint:    z:=idinteger;
           xfloat:  z:=idfloat;
           xchar:   z:=idchar; //??
           xstring: z:=idstring;
      else z:=idundef
      end;
      x:=xnil;
      stack:=cons(z,stack);
      z:=xnil//
end;

procedure fname;
begin if (stack=xnil) then raise exception.create(enamestacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xident) then raise exception.create(enametypenoident);
      stack:=cons(newcharseq(cell[cell[x].pname].pstr^),stack);
      x:=xnil
end;

procedure faddr;
begin if (stack=xnil) then raise exception.create(eaddrstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      stack:=cons(newfloat(x),stack);
      x:=xnil
end;

procedure fbody;
begin if (stack=xnil) then raise exception.create(ebodystacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xident) then raise exception.create(ebodytypenoident);
      y:=cell[x].value;
      if (typeof[y]=xint) then stack:=cons(newfloat(cell[y].inum),stack)
      else if (typeof[y]=xcons) then stack:=cons(y,stack)
      else stack:=cons(idundef,stack);
      x:=xnil;
      y:=xnil
end;

procedure fuser;
begin if (stack=xnil) then raise exception.create(euserstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xident) then raise exception.create(eusertypenoident);
      y:=cell[x].value;
      if      (typeof[y]=xint)  then stack:=cons(idfalse,stack)
      else if (typeof[y]=xcons) then stack:=cons(idtrue,stack)
      else stack:=cons(idfalse,stack); // user or not? ,xnil
      x:=xnil;
      y:=xnil
end;

procedure fi;
begin if (stack=xnil) then raise exception.create(eistacknull);
      efun:=cell[stack].addr;
      stack:=cell[stack].decr;
      eval
end;//mit mjoyA vergleichen !!!

procedure fdip;
begin if (stack=xnil) then raise exception.create(edipstacknull);
      efun:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(edipstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      estack:=cons(x,estack);
      x:=xnil;
      try eval;
          stack:=cons(cell[estack].addr,stack);
          estack:=cell[estack].decr;
      except estack:=cell[estack].decr;
             raise
      end
end;

procedure fif;//branch
begin if (stack=xnil) then raise exception.create(eifstacknull);
      z:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eifstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eifstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if      (x=idtrue)  then efun:=y//
      else if (x=idfalse) then efun:=z//
      else raise exception.create(eiftypenobool);
      x:=xnil;
      y:=xnil;
      z:=xnil;
      //
      eval;//prov if->eval
end;

procedure fbranch;//branch
begin if (stack=xnil) then raise exception.create(ebranchstacknull);
      z:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(ebranchstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(ebranchstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if      (x=idtrue)  then efun:=y//
      else if (x=idfalse) then efun:=z//
      else raise exception.create(ebranchtypenobool);
      x:=xnil;
      y:=xnil;
      z:=xnil;
      //
      eval;//prov if->eval
end;

procedure fchoice;
begin if (stack=xnil) then raise exception.create(echoicestacknull);
      z:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(echoicestacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(echoicestacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if      (x=idtrue)  then stack:=cons(y,stack)
      else if (x=idfalse) then stack:=cons(z,stack)
      else raise exception.create(echoicetypenobool);
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure fselect;
begin if (stack=xnil) then raise exception.create(eselectstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eselectstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((typeof[y]=xnull) or (typeof[y]=xcons)) then
         raise exception.create(eselecttypenolist);
      z:=xnil;
      while (y<>xnil) do begin
         efun:=cell[y].addr;
         if (typeof[efun]<>xcons) then raise exception.create(eselectnocons);
         if equal(x,cell[efun].addr) then begin z:=cell[efun].decr; break end;
         y:=cell[y].decr//
      end;
      stack:=cons(z,stack);
      efun:=xnil;
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure fcond;
begin if (stack=xnil) then raise exception.create(econdstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((typeof[x]=xnull) or (typeof[x]=xcons)) then
         raise exception.create(econdtypenolist);
      estack:=cons(x,estack);
      while (x<>xnil) do begin
         y:=cell[x].addr;
         if (typeof[y]<>xcons) then begin estack:=cell[estack].decr;
                                          raise exception.create(econdnocons)
                                    end;
         efun:=cell[y].addr;
         eval;
         if (stack=xnil) then begin estack:=cell[estack].decr;
                                    raise exception.create(econdstacknull)
                              end;
         x:=cell[stack].addr;
         stack:=cell[stack].decr;
         if (x=idtrue) then begin efun:=cell[cell[cell[estack].addr].addr].decr;
                                  estack:=cell[estack].decr;
                                  //x ,y    xnil
                                  eval;
                                  exit
                            end;
         if (x<>idfalse) then begin estack:=cell[estack].decr;
                                    raise exception.create(econdnobool)
                              end;
         x:=cell[cell[estack].addr].decr;
         cell[estack].addr:=x
      end;
      estack:=cell[estack].decr;
      //stack:=cons(xnil,stack);
      x:=xnil;
      y:=xnil
end;

procedure ftry;
var txt: string;
begin if (stack=xnil) then raise exception.create(etrystacknull);
      efun:=cell[stack].addr;
      stack:=cell[stack].decr;
      try eval;
          stack:=cons(xnil,stack);
      except on e: exception do begin
                txt:=e.message;
                precom(txt);
                stack:=cons(cstack,stack)
             end;
      end
end;

procedure fstep;// [liste] [term] step   ,bis [liste] = []
begin if (stack=xnil) then raise exception.create(estepstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(estepstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((x=xnil) or (typeof[x]=xcons)) then
         raise exception.create(esteptypenolist);
      estack:=cons(y,estack);//term
      estack:=cons(x,estack);//liste
      //x:=xnil;
      y:=xnil;
      //x:=cell[estack].addr; ^^^
      try while (x<>xnil) do begin
                stack:=cons(cell[x].addr,stack);
                efun:=cell[cell[estack].decr].addr;
                eval;
                x:=cell[cell[estack].addr].decr;
                cell[estack].addr:=x
          end;//
          estack:=cell[cell[estack].decr].decr//
      except estack:=cell[cell[estack].decr].decr;
             raise
      end;
      //
end;

procedure frollup;
begin if (stack=xnil) then raise exception.create(erollupstacknull);
      z:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(erollupstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(erollupstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      stack:=cons(y,cons(x,cons(z,stack)));
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure frolldown;
begin if (stack=xnil) then raise exception.create(erolldownstacknull);
      z:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(erolldownstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(erolldownstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      stack:=cons(x,cons(z,cons(y,stack)));
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure frotate;
begin if (stack=xnil) then raise exception.create(erotatestacknull);
      z:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(erotatestacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(erotatestacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      stack:=cons(x,cons(y,cons(z,stack)));
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure ftimes;
var n: int64;
begin if (stack=xnil) then raise exception.create(etimesstacknull);
      efun:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(etimesstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      try n:=round(cell[x].fnum);
          x:=xnil
      except raise//...
      end;
      if (n<0) then n:=0;//...
      estack:=cons(efun,estack);
      try while (n>0) do begin
                efun:=cell[estack].addr;
                eval;//...
                dec(n)
          end;
          estack:=cell[estack].decr
      except estack:=cell[estack].decr;
             raise//...
      end;
      end;

procedure fwhile;
begin if (stack=xnil) then raise exception.create(ewhilestacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(ewhilestacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      estack:=cons(y,cons(x,estack));
      try while true do begin
                efun:=cell[cell[estack].decr].addr;
                eval;//...
                if (stack=xnil) then raise exception.create(ewhilestacknullforbool);
                x:=cell[stack].addr;
                stack:=cell[stack].decr;
                if (x=idfalse) then break;
                if (x<>idtrue) then raise exception.create(ewhiletypenobool);
                efun:=cell[estack].addr;
                eval//...
          end;
          estack:=cell[cell[estack].decr].decr;
          x:=xnil;
          y:=xnil
      except estack:=cell[cell[estack].decr].decr;
             raise//...
      end
end;

procedure findex;
var n: int64;
begin if (stack=xnil) then raise exception.create(eindexstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(eindextypenofloat);
      try n:=round(cell[x].fnum)
      except raise exception.create(eindexrounderror)
      end;
      y:=stack;
      if (n<0) then raise exception.create(eindexoutofrange);
      if (n=0) then stack:=cons(x,stack)
      else begin
         while ((n>1) and (y<>xnil)) do begin
               y:=cell[y].decr;
               dec(n)
         end;
         if (y=xnil) then raise exception.create(eindexoutofrange);
         if (n>1) then raise exception.create(eindexoutofrange);//    ???
         stack:=cons(cell[y].addr,stack)
      end;
      x:=xnil;
      y:=xnil
end;

procedure freverse;
begin if (stack=xnil) then raise exception.create(ereversestacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((x=xnil) or (typeof[x]=xcons)) then
         raise exception.create(ereversetypenolist);
      y:=xnil;
      while (x<>xnil) do begin
            y:=cons(cell[x].addr,y);
            x:=cell[x].decr
      end;
      stack:=cons(y,stack);
      x:=xnil;
      y:=xnil
end;

procedure fsize;
var n: cardinal;
begin if (stack=xnil) then raise exception.create(esizestacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((x=xnil) or (typeof[x]=xcons)) then
         raise exception.create(esizetypenolist);
      n:=0;
      while (x<>xnil) do begin inc(n);
                               x:=cell[x].decr
                         end;
      stack:=cons(newfloat(n),stack);
      x:=xnil
end;

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

procedure ftake;
var n: int64;
begin if (stack=xnil) then raise exception.create(etakestacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(etakestacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((typeof[x]=xcons) or (x=xnil)) then
         raise exception.create(etaketypenolist);
      if (typeof[y]<>xfloat) then raise exception.create(etaketypenofloat);
      try n:=round(cell[y].fnum)
      except raise exception.create(etakerounderror)
      end;
      z:=xnil;
      while ((n>0) and (x<>xnil)) do begin z:=cons(cell[x].addr,z);
                                           dec(n);
                                           x:=cell[x].decr
                                     end;
      nreverse(z);
      stack:=cons(z,stack);
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure fdrop;
var n: int64;
begin if (stack=xnil) then raise exception.create(edropstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(edropstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((typeof[x]=xcons) or (x=xnil)) then
         raise exception.create(edroptypenolist);
      if (typeof[y]<>xfloat) then raise exception.create(edroptypenofloat);
      try n:=round(cell[y].fnum)
      except raise exception.create(edroprounderror)
      end;
      //if (n<0) then n:=0;
      while ((n>0) and (x<>xnil)) do begin dec(n);
                                           x:=cell[x].decr
                                     end;
      stack:=cons(x,stack);
      x:=xnil;
      y:=xnil
end;

procedure fconcat;
var p: cardinal;
begin if (stack=xnil) then raise exception.create(econcatstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(econcatstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((typeof[x]=xcons) or (x=xnil)) then
         raise exception.create(econcattypenolist);
      if not((typeof[y]=xcons) or (y=xnil)) then
         raise exception.create(econcattypenolist);
      z:=xnil;
      while (x<>xnil) do begin
            z:=cons(cell[x].addr,z);
            x:=cell[x].decr
      end;
      //y=restliste
      while (z<>xnil) do begin
            p:=z;
            z:=cell[z].decr;
            cell[p].decr:=y;
            y:=p
      end;
      stack:=cons(y,stack);
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure fswoncat;
var p: cardinal;
begin if (stack=xnil) then raise exception.create(eswoncatstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eswoncatstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((typeof[x]=xcons) or (x=xnil)) then
         raise exception.create(eswoncattypenolist);
      if not((typeof[y]=xcons) or (y=xnil)) then
         raise exception.create(eswoncattypenolist);
      z:=xnil;
      while (x<>xnil) do begin
            z:=cons(cell[x].addr,z);
            x:=cell[x].decr
      end;
      //y=restliste
      while (z<>xnil) do begin
            p:=z;
            z:=cell[z].decr;
            cell[p].decr:=y;
            y:=p
      end;
      stack:=cons(y,stack);
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure fiota;
var n: int64;
begin if (stack=xnil) then raise exception.create(eiotastacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(eiotatypenofloat);
      try n:=round(cell[x].fnum)
      except raise exception.create(eiotarounderror)
      end;
      if (n<0) then n:=0;//...
      y:=xnil;
      while (n>0) do begin y:=cons(newfloat(n),y);
                           dec(n)
                     end;
      stack:=cons(y,stack);
      x:=xnil;
      y:=xnil
end;

procedure fget;
//var p: cardinal; //efun
begin if (stack=xnil) then raise exception.create(egetstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(egetstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((typeof[x]=xcons) or (x=xnil)) then
         raise exception.create(egettypenolist);
      if (typeof[y]<>xident) then raise exception.create(egettypenoident);
      z:=idundef;
      while (x<>xnil) do begin
         efun:=cell[x].addr;
         x:=cell[x].decr;
         if (x=xnil) then raise exception.create(egetkeynovalue);
         if (efun=y) then begin z:=cell[x].addr; break end;
         x:=cell[x].decr
      end;
      stack:=cons(z,stack);
      x:=xnil;
      y:=xnil;
      z:=xnil//
end;
                // x    y   z
procedure fput; // dict key value -- dict
begin if (stack=xnil) then raise exception.create(eputstacknull);
      z:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eputstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eputstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((typeof[x]=xcons) or (x=xnil)) then
         raise exception.create(eputtypenolist);
      if (typeof[y]<>xident) then raise exception.create(eputtypenoident);
      efun:=xnil; //rev
      while (x<>xnil) do begin
         if (y=cell[x].addr) then break;
         efun:=cons(cell[x].addr,efun);
         x:=cell[x].decr;
         if (x=xnil) then raise exception.create(eputkeynovalue);
         efun:=cons(cell[x].addr,efun);
         x:=cell[x].decr
      end;
      if (x<>xnil) then begin
         x:=cell[x].decr;
         if (x=xnil) then raise exception.create(eputkeynovalue);
         x:=cell[x].decr
      end;
      x:=cons(y,cons(z,x));
      //x=restliste
      while (efun<>xnil) do begin
            z:=efun;
            efun:=cell[efun].decr;
            cell[z].decr:=x;
            x:=z
      end;
      stack:=cons(x,stack);
      //efun:=xnil;
      x:=xnil;
      y:=xnil;
      z:=xnil//
end;

procedure fpred;
begin if (stack=xnil) then raise exception.create(epredstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if      (typeof[x]=xfloat) then
         stack:=cons(newfloat(cell[x].fnum - 1),stack)
      else if (typeof[x]=xchar)  then
         stack:=cons(newchar(pred(cell[x].ch)),stack)// pred(#0)?
      else raise exception.create(epredtypenonum);//?
      x:=xnil
end;

procedure fsucc;
begin if (stack=xnil) then raise exception.create(esuccstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if      (typeof[x]=xfloat) then
         stack:=cons(newfloat(cell[x].fnum + 1),stack)
      else if (typeof[x]=xchar)  then
         stack:=cons(newchar(succ(cell[x].ch)),stack)// succ(max)?
      else raise exception.create(esucctypenonum);//?
      x:=xnil
end;

procedure frad;
begin if (stack=xnil) then raise exception.create(eradstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(eradtypenofloat);
      stack:=cons(newfloat(degtorad(cell[x].fnum)),stack);
      x:=xnil
end;

procedure fdeg;
begin if (stack=xnil) then raise exception.create(edegstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(edegtypenofloat);
      stack:=cons(newfloat(radtodeg(cell[x].fnum)),stack);
      x:=xnil
end;

procedure fpi;
begin stack:=cons(newfloat(pi),stack)
end;

procedure f2pi;
begin stack:=cons(newfloat(pi+pi),stack)
end;

procedure fsin;
begin if (stack=xnil) then raise exception.create(esinstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(esintypenofloat);
      stack:=cons(newfloat(sin(cell[x].fnum)),stack);
      x:=xnil
end;

procedure fcos;
begin if (stack=xnil) then raise exception.create(ecosstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(ecostypenofloat);
      stack:=cons(newfloat(cos(cell[x].fnum)),stack);
      x:=xnil
end;

procedure ftan;
begin if (stack=xnil) then raise exception.create(etanstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(etantypenofloat);
      stack:=cons(newfloat(tan(cell[x].fnum)),stack);  //try?
      x:=xnil
end;

procedure fasin;
begin if (stack=xnil) then raise exception.create(easinstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(easintypenofloat);
      stack:=cons(newfloat(arcsin(cell[x].fnum)),stack);
      x:=xnil
end;

procedure facos;
begin if (stack=xnil) then raise exception.create(eacosstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(eacostypenofloat);
      stack:=cons(newfloat(arccos(cell[x].fnum)),stack);
      x:=xnil
end;

procedure fatan;
begin if (stack=xnil) then raise exception.create(eatanstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(eatantypenofloat);
      stack:=cons(newfloat(arctan(cell[x].fnum)),stack);  //try?
      x:=xnil
end;

procedure fatan2;
begin if (stack=xnil) then raise exception.create(eatan2stacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(eatan2stacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(eatan2typenofloat);
      if (typeof[y]<>xfloat) then raise exception.create(eatan2typenofloat);
      stack:=cons(newfloat(arctan2(cell[y].fnum,cell[x].fnum)),stack);  //try?
      x:=xnil;
      y:=xnil
end;

procedure fsinh;
begin if (stack=xnil) then raise exception.create(esinhstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(esinhtypenofloat);
      stack:=cons(newfloat(sinh(cell[x].fnum)),stack);
      x:=xnil
end;

procedure fcosh;
begin if (stack=xnil) then raise exception.create(ecoshstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(ecoshtypenofloat);
      stack:=cons(newfloat(cosh(cell[x].fnum)),stack);
      x:=xnil
end;

procedure ftanh;
begin if (stack=xnil) then raise exception.create(etanhstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(etanhtypenofloat);
      stack:=cons(newfloat(tanh(cell[x].fnum)),stack);
      x:=xnil
end;

procedure fsqrt;
begin if (stack=xnil) then raise exception.create(esqrtstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(esqrttypenofloat);
      stack:=cons(newfloat(sqrt(cell[x].fnum)),stack);  //try?
      x:=xnil
end;

procedure fupper;
var s: string;
begin if (stack=xnil) then raise exception.create(eupperstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xchar) then raise exception.create(euppertypenochar);
      s:=ansiuppercase(cell[x].ch);
      if (s[1]<=#255) then stack:=cons(cindex[ord(s[1])],stack)
                      else stack:=cons(newchar(s[1]),stack);
      x:=xnil
end;

procedure flower;
var s: string;
begin if (stack=xnil) then raise exception.create(elowerstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xchar) then raise exception.create(elowertypenochar);
      s:=ansilowercase(cell[x].ch);
      if (s[1]<=#255) then stack:=cons(cindex[ord(s[1])],stack)
                      else stack:=cons(newchar(s[1]),stack);
      x:=xnil
end;

procedure fchr;
var n: int64;
begin if (stack=xnil) then raise exception.create(echrstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(echrtypenofloat);
      n:=round(cell[x].fnum);// try?
      if not((0<=n) and (n<=65535)) then raise exception.create(echroutofrange);
      if (n<=255) then stack:=cons(cindex[n],stack)
                  else stack:=cons(newchar(chr(n)),stack);
      x:=xnil
end;

procedure ford;
begin if (stack=xnil) then raise exception.create(eordstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xchar) then raise exception.create(eordtypenochar);
      stack:=cons(newfloat(ord(cell[x].ch)),stack);
      x:=xnil
end;

procedure frgb;
begin if (stack=xnil) then raise exception.create(ergbstacknull);
      z:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(ergbstacknull);
      y:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (stack=xnil) then raise exception.create(ergbstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create(ergbtypenofloat);
      if (typeof[y]<>xfloat) then raise exception.create(ergbtypenofloat);
      if (typeof[z]<>xfloat) then raise exception.create(ergbtypenofloat);
      stack:=cons(newfloat(RGB( round(cell[x].fnum),
                                round(cell[y].fnum),
                                round(cell[z].fnum) )),stack);//try?     !!!!!!!!!!
      x:=xnil;
      y:=xnil;
      z:=xnil
end;

procedure fgc;
begin gc(xnil,xnil)
end;

procedure fconts;  //buggy...
begin stack:=cons(estack,stack)//???
end;

procedure fout;
begin if (stack=xnil) then raise exception.create(eoutstacknull);
      servprint(tovalue(cell[stack].addr));//bitte kompackter? ,ok-Haken
      stack:=cell[stack].decr
end;

procedure fquit;
begin onquit:=true;
      raise exception.create('onquit = true')
      //if (guiform<>nil) then guiform.close
end;

procedure fgettime;
begin stack:=cons(newfloat(gettime),stack)
end;

procedure fprinttime;
begin if (stack=xnil) then raise exception.create('time-error-stacknull');
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]<>xfloat) then raise exception.create('time-error-nofloat');
      servprint(timetostr(cell[x].fnum))//
end;

procedure fidentlist;
begin stack:=cons(identlist,stack)
end;

procedure fparse;
var s: string;
begin if (stack=xnil) then raise exception.create(eparsestacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if not((typeof[x]=xcons) or (x=xnil)) then
         raise exception.create(eparsetypenolist);
      s:=seqtostring(x);
      precom(s);
      stack:=cons(cstack,stack);
      cstack:=xnil;
      x:=xnil
end;

procedure ftostr;
begin if (stack=xnil) then raise exception.create(etostrstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      stack:=cons(newcharseq(tovalue(x)),stack);
      x:=xnil
end;

procedure fmaxcell;
begin stack:=cons(newfloat(maxcell),stack)
end;

procedure ferror;
var s: string;
begin if (stack=xnil) then raise exception.create(eerrorstacknull);
      x:=cell[stack].addr;
      stack:=cell[stack].decr;
      if (typeof[x]=xcons) then s:=tosequence(x)
                           else s:=tovalue(x);
      x:=xnil;
      raise exception.create(s)
end;

//------------------------- Initialisierung ----------------------------

function newidentproc(s: string;p: mjproc): cardinal;
begin inc(pcounter);
      newidentproc:=newident(s,newint(pcounter));
      proc[pcounter]:=p
end;

procedure initidentprimitives;
var i: longint;
begin for i:=0 to maxproc do proc[i]:=fundefined;
      pcounter:=0;
      //
      idmark:=newident('<c mark>',xnil);
      iddef:= newident('==',xnil);
      newidentproc(qot,fquote);
      {idbottom:=newident('_',xnil)};//prov
      {idmonad:=newident('!',xnil)}; //prov
      //         newidentproc('.',fdot);
      newidentproc('stack',fstack);
      newidentproc('unstack',funstack);
      //newidentproc('clear',fclear);                    //prov
      newidentproc('id',fid);
      newidentproc('dup',fdup);
      newidentproc('pop',fpop);
      newidentproc('swap',fswap);
      newidentproc('over',fover);
      newidentproc('rotate',frotate);
      newidentproc('rollup',frollup);
      newidentproc('rolldown',frolldown);
      newidentproc('first',ffirst);
      newidentproc('rest',frest);
      idcons:=newidentproc('cons',fcons);
      newidentproc('uncons',funcons);//uncons
      newidentproc('swons',fswons);
      newidentproc('unswons',funswons);
      //
      newidentproc('+',fadd);
      newidentproc('-',fsub);
      newidentproc('*',fmul);
      newidentproc('/',fdiv);
      newidentproc('pow',fpow);//pow;
      newidentproc('pred',fpred);
      newidentproc('succ',fsucc);
      newidentproc('sign',fsign);
      newidentproc('abs',fabs);//abs
      newidentproc('neg',fneg);//neg
      newidentproc('int',fint);
      newidentproc('round',fround);//round
      //trunc (int?)  ,mod?
      newidentproc('exp',fexp);//exp
      newidentproc('log',flog);//log
      newidentproc('log10',flog10);//log10
      newidentproc('log2',flog2);
      idtrue:=newidentproc('true',ftrue);
      idfalse:=newidentproc('false',ffalse);
      newidentproc('=',feq);
      newidentproc('<',flt);//<     ,etc
      //equal (tree)
      newidentproc('not',fnot);//not
      newidentproc('and',fand);//and
      newidentproc('or',f_or);//or
      newidentproc('xor',fxor);//xor
      //
      idnull:=newidentproc('null',fnull);       //proc ...
      newidentproc('list',flist);
      newidentproc('logical',flogical);//logical
      //idnull:=newidentproc('null',fnull)
      //idcons:=newidentproc('cons',);
      //consp
      newidentproc('consp',fconsp);
      idident:=newidentproc('ident',fident);
      idinteger:=newident('integer',xnil);
      idfloat:=newidentproc('float',ffloat);
      idchar:=newidentproc('char',fchar);
      idstring:=newident('string',xnil);
      idundef:=newidentproc('undef',fundef);
      newidentproc('user',fuser);
      //charseq
      newidentproc('type',ftype);
      newidentproc('name',fname);//name
      newidentproc('body',fbody);//body
      //intern
      newidentproc('addr',faddr);
      newidentproc('i',fi);
      newidentproc('dip',fdip);            // noch austesten !!!!!
      newidentproc('if',fif);
      newidentproc('branch',fbranch);   //???
      newidentproc('choice',fchoice);
      newidentproc('select',fselect);
      newidentproc('cond',fcond);
      newidentproc('try',ftry);
      newidentproc('step',fstep);             // !!!  testen bei Fehlerfall  !!!
      newidentproc('times',ftimes);
      newidentproc('while',fwhile);
      newidentproc('index',findex);//index x,1..n
      //setindex      ,swetindex?
      //at    [0..n-1]   //of
      //set
      //list (=listp)
      //list ... anderer name
      newidentproc('reverse',freverse);//reverse
      idsize:=newidentproc('size',fsize);//length count size
      newidentproc('take',ftake);//take
      newidentproc('drop',fdrop);//drop
      newidentproc('concat',fconcat);//concat
      newidentproc('swoncat',fswoncat);//swoncat
      newidentproc('iota',fiota);
      newidentproc('get',fget);//get
      newidentproc('put',fput);//put
      //rem (remove);
      newidentproc('rad',frad);
      newidentproc('deg',fdeg);
      newidentproc('pi',fpi);
      newidentproc('2pi',f2pi);//2pi
      newidentproc('sin',fsin);
      newidentproc('cos',fcos);
      newidentproc('tan',ftan);//tan
      newidentproc('asin',fasin);//asin
      newidentproc('acos',facos);//acos
      newidentproc('atan',fatan);//atan
      //sinh, cosh, tanh   ,atan2
      newidentproc('atan2',fatan2);
      newidentproc('sinh',fsinh);
      newidentproc('cosh',fcosh);
      newidentproc('tanh',ftanh);
      newidentproc('sqrt',fsqrt);//sqrt
      newidentproc('upper',fupper);
      newidentproc('lower',flower);
      newidentproc('chr',fchr);
      newidentproc('ord',ford);
      ;
      ;
      //        newidentproc('showgraph',fshowgraph);
      //        newidentproc('print',fprint);
      newidentproc('min',fmin);
      newidentproc('max',fmax);
      newidentproc('rgb',frgb);
      newidentproc('gc',fgc);
      newidentproc('conts',fconts);//conts   estack       //prov  buggy!!!
      newidentproc('out',fout);//seiteneffekt
      newidentproc('quit',fquit);            //??? dooooiiing       !!!!!!!!!!!!!!!
      //
      idpen:=newident('pen',xnil);
      idcolor:=newident('color',xnil);
      //idsize:=newident('size',xnil);
      idbrush:=newident('brush',xnil);
      idcircle:=newident('circle',xnil);
      idrect:=newident('rect',xnil);
      //provi
      newidentproc('time',fgettime);
      newidentproc('printtime',fprinttime);
      //newidentproc('loadstring',floadstring);
      newidentproc('identlist',fidentlist);
      newidentproc('parse',fparse);
      newidentproc('tostr',ftostr);
      newidentproc('maxcell',fmaxcell);
      newidentproc('error',ferror);
      //
end;

{procedure initidents;
begin ;
              ;//try        proc[25]:=;
              ;//rot (?)   rotate    proc[26]:=;
              ;//    proc[46]:=;
              ;//    proc[47]:=;
              ;//graph  proc[48]:=;  ,wenn height=0 dann height anpassen
              ;//print       proc[49]:=;
              ;//pi  (50)       proc[50]:=;
              ;//sin     proc[51]:=;
              ;//cos     proc[52]:=;
              //
end;}

{procedure initprimitives; //table
var i: longint;
begin for i:=0 to maxproc do proc[i]:=fundef;
      ;
end;}

end.


// (CC BY 3.0 DE) Fpstefan
