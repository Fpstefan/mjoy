unit guiunit;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants,
  System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Buttons, Vcl.StdCtrls,
  Vcl.Menus, Vcl.ComCtrls, Vcl.ImgList,
  Registry,shellapi,clipbrd;//System.Types

type
  Tmjform = class(TForm)
    mjpanel: TPanel;
    mjbanner: TPanel;
    mjimage: TImage;
    iopanel: TPanel;
    toolpanel: TPanel;
    mjpaintbox: TPaintBox;
    mjsplitter: TSplitter;
    iomemo: TMemo;
    adpanel: TPanel;
    doitbutton: TSpeedButton;
    pstackbutton: TSpeedButton;
    dumpbutton: TSpeedButton;
    Bevel1: TBevel;
    openbutton: TSpeedButton;
    openlastbutton: TSpeedButton;
    Bevel2: TBevel;
    cutbutton: TSpeedButton;
    copybutton: TSpeedButton;
    pastebutton: TSpeedButton;
    Bevel3: TBevel;
    favorbutton: TSpeedButton;
    helpbutton: TSpeedButton;
    mjopendialog: TOpenDialog;
    mjtimer: TTimer;
    mjPopupMenu: TPopupMenu;
    savememodialog: TSaveDialog;
    savepictdialog: TSaveDialog;
    convRichEdit: TRichEdit;
    doititem: TMenuItem;
    stackdotitem: TMenuItem;
    dumpitem: TMenuItem;
    stopmitem: TMenuItem;
    N1item: TMenuItem;
    undoitem: TMenuItem;
    cutitem: TMenuItem;
    copyitem: TMenuItem;
    pasteitem: TMenuItem;
    delitem: TMenuItem;
    selallitem: TMenuItem;
    N2item: TMenuItem;
    openitem: TMenuItem;
    openlastitem: TMenuItem;
    savememoitem: TMenuItem;
    savepictitem: TMenuItem;
    inititem: TMenuItem;
    websiteitem: TMenuItem;
    guideitem: TMenuItem;
    dochelpitem: TMenuItem;
    refhelpitem: TMenuItem;
    favoritem: TMenuItem;
    toolitem: TMenuItem;
    N3item: TMenuItem;
    quititem: TMenuItem;
    ImageList1: TImageList;
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure mjimageMouseEnter(Sender: TObject);
    procedure mjimageMouseLeave(Sender: TObject);
    procedure iomemoKeyPress(Sender: TObject; var Key: Char);
    procedure doititemClick(Sender: TObject);
    procedure stackdotitemClick(Sender: TObject);
    procedure dumpitemClick(Sender: TObject);
    procedure stopmitemClick(Sender: TObject);
    procedure undoitemClick(Sender: TObject);
    procedure cutitemClick(Sender: TObject);
    procedure copyitemClick(Sender: TObject);
    procedure pasteitemClick(Sender: TObject);
    procedure delitemClick(Sender: TObject);
    procedure selallitemClick(Sender: TObject);
    procedure openitemClick(Sender: TObject);
    procedure openlastitemClick(Sender: TObject);
    procedure savememoitemClick(Sender: TObject);
    procedure savepictitemClick(Sender: TObject);
    procedure inititemClick(Sender: TObject);
    procedure websiteitemClick(Sender: TObject);
    procedure guideitemClick(Sender: TObject);
    procedure dochelpitemClick(Sender: TObject);
    procedure refhelpitemClick(Sender: TObject);
    procedure favoritemClick(Sender: TObject);
    procedure toolitemClick(Sender: TObject);
    procedure quititemClick(Sender: TObject);
    procedure mjimageMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure mjPopupMenuPopup(Sender: TObject);
    procedure mjpaintboxPaint(Sender: TObject);
    procedure mjtimerTimer(Sender: TObject);
    procedure adpanelDblClick(Sender: TObject);
    procedure FormCanResize(Sender: TObject; var NewWidth, NewHeight: Integer;
      var Resize: Boolean);
    procedure FormResize(Sender: TObject);
    procedure FormIdle(Sender: TObject; var Done: Boolean);
    procedure execprogfile(fname: string);
  private
    { Private-Deklarationen }
  public
    { Public-Deklarationen }
  end;

var
  mjform: Tmjform;

implementation

{$R *.dfm}

uses servunit, errunit, initunit;

const pixelinpopupmenu = 7;
      corefilenamedef = 'core.txt';//nachgucken!!!
      unloaddef = 'ungeladen';
      progfilenotfound = 'Programmdatei nicht gefunden.';
      guidefiledef = 'QuickStartGuide.pdf';//'http://mathscitech.org/papers/mjoy%20-%20drawing%20with%20mjoy%20-%20supplement.pdf';//'Dokumentation.rtf';
      dochelpfiledef = 'Dokumentation.rtf';
      refhelpfiledef = 'Referenz.rtf';
      websitedef = 'https://mjoypro.firebaseapp.com/';
      filenotfound = 'Datei existiert nicht.';
      noinifilename = 'Name für ini-Datei existiert nicht.';
      software='Software';
      mjsection = 'mjoyForm';
      x0 = 'x0';
      y0 = 'y0';
      dx = 'dx';
      dy = 'dy';
      ws = 'windowstate';
      toolbar = 'toolbar';
      paramdef = 'paramfiledef';
      sheetdef = 'sheetfiledef';
      pictdef = 'pictfiledef';
      mcs = 'maxcell';
      x0def = 80;
      y0def = 9;
      dxdef = 390;
      dydef = 340;
      wsdef = wsnormal;
      tbdef=true;
      readinifileerror = 'Kann nicht bearbeitet werden. (readinifile)'#13#10
                         +' Bitte beenden!';
      writeinifileerror = 'Kann nicht geschrieben werden. (writeinifile)';
      initmaxcellerror = 'Kann nicht bearbeitet werden. (maxcell)';

var mjformcaption,exefilename,paramfilename,corefilename:string;//bearbeiten
    inifilename: string = '';
    paramfiledef: string = '';
    sheetfilename: string = '';
    pictfilename: string = '';
    mjinifile: TRegistryIniFile;
    wincoord,prewincoord: trect;//pre-initialisieren

procedure errordialog(s: string; onmodal: boolean);
begin beep;
      if onmodal then
         messagedlg(s,mtError,[mbok],0)
      else begin
         errform.show;
         errform.errmemo.SetFocus;
         errform.errmemo.lines.append(s);
         errform.okButton.SetFocus;
      end;
      mjform.adpanel.caption:=prompt+s;
end;

function readinifile(mc: int64): int64;
var s: string;
begin readinifile:=mc;
      try mjinifile:=TRegistryIniFile.create(inifilename);
          with mjinifile,mjform do begin
               left:=readinteger(mjsection,x0,x0def);
               top:=readinteger(mjsection,y0,y0def);
               width:=readinteger(mjsection,dx,dxdef);
               height:=readinteger(mjsection,dy,dydef);
               wincoord.left:=left;
               wincoord.top:=top;
               wincoord.right:=wincoord.left+width;
               wincoord.bottom:=wincoord.top+height;
               prewincoord:=wincoord;
               if (twindowstate(readinteger(mjsection,ws,ord(wsdef)))=wsMaximized)
               then windowstate:=wsMaximized
               else windowstate:=wsNormal;
               toolpanel.visible:=readbool(mjsection,toolbar,tbdef);
               toolitem.checked:=toolpanel.visible;
               paramfiledef:=readstring(mjsection,paramdef,'');
               sheetfilename:=readstring(mjsection,sheetdef,'');
               pictfilename:=readstring(mjsection,pictdef,'');
               //toolbar;
               mc:=readinteger(mjsection,mcs,mc);
               readinifile:=mc
          end;
          mjinifile.free
      except mjinifile.free;
             s:=inifilename;
             inifilename:='';
             errordialog('"' + s + '" ' + readinifileerror,false)
      end
end;

procedure writeinifile;
begin if (inifilename='') then exit;
      try mjinifile:=TRegistryIniFile.create(inifilename);
          with mjinifile,mjform do begin
               if (windowstate=wsMaximized) then wincoord:=prewincoord;
               writeinteger(mjsection,x0,wincoord.left);
               writeinteger(mjsection,y0,wincoord.top);
               writeinteger(mjsection,dx,wincoord.right-wincoord.left);
               writeinteger(mjsection,dy,wincoord.bottom-wincoord.top);
               writeinteger(mjsection,ws,ord(windowstate));
               writebool(mjsection,toolbar,toolpanel.visible);
               if (paramfilename<>'')then
                  writestring(mjsection,paramdef,paramfilename)
               else writestring(mjsection,paramdef,paramfiledef);
               writestring(mjsection,sheetdef,sheetfilename);
               writestring(mjsection,pictdef,pictfilename);
               //toolbar;
               updatefile
          end;
          mjinifile.free
      except mjinifile.free;
             errordialog('"' + inifilename + '" ' + writeinifileerror,true)
      end
      //
end;

procedure initgui; // ... FP Scriptor
var txt: string; mc: int64;
begin with mjform do
      try mjpaintbox.height:=0;
          mjbanner.color:=rgb(240,240,240);
          mjsplitter.color:=rgb(240,240,240);
          toolpanel.color:=rgb(240,240,240);
          //panelbar.caption:=panelbartextdef;
          mjformcaption:=mjform.caption;
          mjform.caption:=' '+unloaddef+' - '+mjformcaption;
          inifilename:='\'+software+'\'+mjformcaption;
          exefilename:=paramstr(0);
          paramfilename:=paramstr(1);
          corefilename:=extractslashpath(exefilename)+corefilenamedef;
          //
          iomemo.text:={inttostr(sizeof(fpcell))+}prompt;
          iomemo.selstart:=length(mjform.iomemo.text);
          //
          mc:=readinifile(servmaxcelldef);
          if (mc<servmincell) then mc:=servmincell;
          //if (mc>4294967295)  then exception.create('maxcell zu gross.');//???
          //
          Application.OnIdle:=FormIdle;
          //
          redef:=false;
          initserv(mc,mjform.iomemo,mjpaintbox,mjform);//convrichedit einbauen
          //
          if fileexists(corefilename) then begin//if load kernel
             mjform.caption:=' '+extractslashname(corefilename)+' - '+mjformcaption;
             convrichedit.lines.loadFromFile(corefilename);//plaintext?
             txt:=convrichedit.text;
             tellserv(txt);
          end;
          if (paramfilename<>'') then begin
             if fileexists(paramfilename) then begin
                mjform.caption:=' '+extractslashname(paramfilename)+' - '+mjformcaption;
                convrichedit.lines.loadFromFile(paramfilename);//plaintext?;
                txt:=convrichedit.text;
                tellserv(txt);
                //
             end;
             //
          end;
          //paramfilename loading
      except on e: exception do begin
                // quelltext ausgeben
                errordialog(e.message,false);
                //
             end//
      end;
//
end;

procedure finalgui;
begin finalserv;
      writeinifile
end;

procedure doit;
var txt: string;//?
begin with mjform do begin
           if (iomemo.sellength>0) then txt:=iomemo.seltext
           else txt:=selectline(iomemo.text,iomemo.selstart);
           tellserv(txt);//mjform.iomemo.lines.append(prompt);
           redef:=true;
           adpanel.caption:='';
      end
end;

procedure initmaxcell;
var max: int64; s: string;
begin if (inifilename='') then begin errordialog(noinifilename,false);exit end;
      try mjinifile:=TRegistryIniFile.create(inifilename);
          max:=mjinifile.readinteger(mjsection,mcs,servmaxcelldef);
          initForm.cellEdit.text:=inttostr(max);
          if (initForm.showmodal=mrok) then begin
             mjinifile.writestring(mjsection,mcs,initForm.cellEdit.text);
             mjinifile.updatefile
          end;
          mjinifile.free
      except mjinifile.free;
             s:=inifilename;
             inifilename:='';
             errordialog('"' + s + '" ' + initmaxcellerror,false)//
      end
      //
end;

procedure tmjform.execprogfile(fname: string);
const errorcode = 'ERRORCODE';
var res: longint;
begin //panelbar nullstring
      res:=shellexecute(handle,'open'#0,pWideChar(fname),#0,#0,sw_shownormal);//???
      if (res<=32) then
         case res of
              ERROR_FILE_NOT_FOUND: errordialog('"'+fname+'" - '+progfilenotfound,false);
         else errordialog('"'+fname+'" - '+errorcode+' #'+inttostr(res),false)
         end
end;

//------------------------------ Events ----------------------------------------

procedure tmjform.FormIdle(Sender: TObject; var Done: Boolean);
begin try servreaction; Done:=servidledone;
      except //quelltexte ausgeben?
             on e: exception do begin
                if onquit then mjform.close
                else errordialog(e.message,false)//???
                //
             end//
      end// fios mit idle
end;

procedure tmjform.FormResize(Sender: TObject);
begin wincoord.left:=left;
      wincoord.top:=top;
      wincoord.right:=left+width;
      wincoord.bottom:=top+height
end;

procedure tmjform.adpanelDblClick(Sender: TObject);
begin servprint(prompt)
end;

procedure tmjform.copyitemClick(Sender: TObject);
begin iomemo.copytoclipboard
end;

procedure tmjform.cutitemClick(Sender: TObject);
begin iomemo.cuttoclipboard
end;

procedure tmjform.delitemClick(Sender: TObject);
begin iomemo.clearselection
end;

procedure tmjform.websiteitemClick(Sender: TObject);
begin execprogfile(websitedef)//
end;

procedure tmjform.refhelpitemClick(Sender: TObject);
begin execprogfile(extractslashpath(exefilename)+refhelpfiledef)//n
//
end;

procedure tmjform.guideitemClick(Sender: TObject);
begin execprogfile(extractslashpath(exefilename)+guidefiledef)//
end;

procedure tmjform.doititemClick(Sender: TObject);
begin doit
end;

procedure tmjform.dumpitemClick(Sender: TObject);
begin servidentdump
end;

procedure tmjform.FormCanResize(Sender: TObject; var NewWidth,
  NewHeight: Integer; var Resize: Boolean);
begin if (windowstate=wsNormal) then begin
         prewincoord:=wincoord;
         wincoord.left:=left;
         wincoord.top:=top;
         wincoord.right:=left+width;
         wincoord.bottom:=top+height
         //
      end
end;

procedure tmjform.FormClose(Sender: TObject; var Action: TCloseAction);
begin finalgui
end;

procedure tmjform.FormCreate(Sender: TObject);
begin //Application.OnIdle:=FormIdle// idle def//
end;

procedure tmjform.FormShow(Sender: TObject);
begin initgui//hier richtig?
end;

procedure tmjform.stackdotitemClick(Sender: TObject);
begin servprintstack
end;

procedure tmjform.stopmitemClick(Sender: TObject);
begin servstopm
//
end;

procedure tmjform.savepictitemClick(Sender: TObject);
var image: timage;
    h,w: longint;
begin savepictdialog.initialdir:=extractslashpath(pictfilename);
      savepictdialog.filename:=extractslashname(pictfilename);
      if not(savepictdialog.execute) then exit;
      // wie ist es mit überschreiben? nachfragen? ;
      pictfilename:=savepictdialog.filename;
      mjpaintbox.repaint;                             //??? refresh? ,etc?
      image:=timage.create(self);
      h:=mjpaintbox.height;
      w:=mjpaintbox.width;
      try //
          image.height:=h;
          image.width:=w;
          image.canvas.copyrect(rect(0,0,w,h),mjpaintbox.canvas,rect(0,0,w,h));
          image.picture.savetofile(pictfilename);
          adpanel.caption:=prompt+'"'+pictfilename+'" gespeichert';
          image.free;
      except on e: exception do begin
                image.free;
                errordialog(e.message,false);//etc...    // ,???
             end//genauer     errordialog?
      end//
end;

procedure tmjform.iomemoKeyPress(Sender: TObject; var Key: Char);
begin if (key=#13) then begin doit;
                              key:=#27;
                              exit
                        end
//
end;

procedure tmjform.mjimageMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
var t: tpoint;
begin t:=mjimage.clienttoscreen(point(x,y));
      mjpopupmenu.Popup(t.x-pixelinpopupmenu,t.y-pixelinpopupmenu)
end;

procedure tmjform.mjimageMouseEnter(Sender: TObject);
begin mjbanner.color:=rgb(255,202,20)//rgb(26,170,33)
end;

procedure tmjform.mjimageMouseLeave(Sender: TObject);
begin mjbanner.color:=rgb(240,240,240)//clBtnFace      //anpassen!
end;

procedure tmjform.mjpaintboxPaint(Sender: TObject);
begin try if (mjpaintbox.height>0) then servdrawtrail
      except on e: exception do begin
                // quelltext ausgeben
                errordialog(e.message,false)//???
                //
             end//raise
      end
end;

procedure tmjform.mjPopupMenuPopup(Sender: TObject);
begin undoitem.enabled:=iomemo.canundo;
      cutitem.enabled :=(iomemo.sellength>0);
      copyitem.enabled:=(iomemo.sellength>0);
      pasteitem.enabled:=clipboard.hasformat(CF_TEXT);
      delitem.enabled:=(iomemo.sellength>0);
      //
end;

procedure tmjform.mjtimerTimer(Sender: TObject);   //test !!!!!!!!
begin try //servreaction;            //zum Test abgeschaltet
      except //quelltexte ausgeben?
             on e: exception do begin
                if onquit then mjform.close
                else errordialog(e.message,false)//???
                //
             end//
      end// fios mit idle
end;

procedure tmjform.openitemClick(Sender: TObject);
var txt: string;//?
begin if (paramfilename='') then paramfilename:=paramfiledef;
      mjopendialog.initialdir:=extractslashpath(paramfilename);
      mjopendialog.filename:=extractslashname(paramfilename);
      if mjopendialog.execute then begin
         paramfilename:=mjopendialog.filename;
         mjform.caption:=' '+extractslashname(paramfilename)+' - '+mjformcaption;
         convrichedit.lines.loadfromfile(paramfilename);//plaintext?
         txt:=convrichedit.text;
         tellserv(txt);
         redef:=true;
         adpanel.caption:=prompt+'"'+paramfilename+'" geladen';
      end  //try vergessen
end;

procedure tmjform.openlastitemClick(Sender: TObject);
var txt: string;//?
begin if (paramfilename='') then paramfilename:=paramfiledef;
      if not(fileexists(paramfilename)) then
         errordialog('"'+paramfilename+'" - '+filenotfound,false)
      else begin
         mjform.caption:=' '+extractslashname(paramfilename)+' - '+mjformcaption;
         convrichedit.lines.loadfromfile(paramfilename);//plaintext?
         txt:=convrichedit.text;
         tellserv(txt);
         redef:=true;
         adpanel.caption:=prompt+'"'+paramfilename+'" geladen';
      end //try vergessen
end;

procedure tmjform.pasteitemClick(Sender: TObject);
begin iomemo.pastefromclipboard
end;

procedure tmjform.quititemClick(Sender: TObject);
begin mjform.close
end;

procedure tmjform.dochelpitemClick(Sender: TObject);
begin execprogfile(extractslashpath(exefilename)+dochelpfiledef)//
      //
//
end;

procedure tmjform.savememoitemClick(Sender: TObject);
begin savememodialog.initialdir:=extractslashpath(sheetfilename);
      savememodialog.filename:=extractslashname(sheetfilename);
      if not(savememodialog.execute) then exit;
      try sheetfilename:=savememodialog.filename;
          iomemo.lines.savetofile(sheetfilename);
          adpanel.caption:=prompt+'"'+sheetfilename+'" gespeichert';
          //
      except on e: exception do begin
                errordialog(e.message,false);//etc...  // ,???
             end//
      end//
end;

procedure tmjform.selallitemClick(Sender: TObject);
begin iomemo.selectall
end;

procedure tmjform.undoitemClick(Sender: TObject);
begin
if iomemo.canundo then iomemo.undo
end;

procedure tmjform.inititemClick(Sender: TObject);
begin initmaxcell
end;

//------------------------------------------------------------------------------

procedure Tmjform.favoritemClick(Sender: TObject);
begin servtogglepaintbox
end;

procedure Tmjform.toolitemClick(Sender: TObject);
begin toolpanel.visible:=not(toolpanel.visible);
      toolitem.checked:=toolpanel.visible
end;

end. // (c) 2016.08 - 2018.07 Stefan Cygon
