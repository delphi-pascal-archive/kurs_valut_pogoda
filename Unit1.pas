unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, idHTTP, Menus, ExtCtrls,Clipbrd, ComCtrls,INIFiles;

type TVal=record
  Typ:String;
  Edizm:String;
  Date:TDateTime;
  Value:Real;
  Incr:Real;
end;

type
  TForm1 = class(TForm)
    Label1: TLabel;
    Button1: TButton;
    procedure Button1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  Form1: TForm1;
  HTTP: TIdHTTP;

implementation

uses DateUtils;

{$R *.dfm}

procedure TForm1.Button1Click(Sender: TObject);
var
 S: TStringList;
 P,I: integer;
 USD,EUR,AFS,pM,pP: string;
begin
 HTTP:=TIdHTTP.Create(nil);
 HTTP.HandleRedirects:=True;
 HTTP.ProtocolVersion:=pv1_0;
 HTTP.ProtocolVersion:=pv1_0;
 //
 S:=TStringList.Create;
 S.Text:=HTTP.Get('http://www.rbc.ru/out/802.csv');
 // Курс валют
 P:=S.IndexOf('#---- Курсы ЦБ РФ ----');
 //
 if not (P=-1)
 then
  begin
   for i:=0 to 5 do
    begin
     inc(P);
     if Pos('USD ЦБ РФ',S.Strings[p])>0
     then USD:=S.Strings[p];
     if Pos('EUR ЦБ РФ',S.Strings[p])>0
     then EUR:=S.Strings[p];
     if Pos('GBP ЦБ РФ',S.Strings[p])>0
     then AFS:=S.Strings[p];     
    end;
   // USD ЦБ РФ,1 Доллар США,27/02,31.6065,0.019
   // EUR ЦБ РФ,1 ЕВРО,27/02,34.0118,-0.1311
  end;
 Delete(USD,1,pos('/',USD));
 Delete(USD,1,pos(',',USD));
 Delete(USD,pos(',',USD),20);
 Delete(EUR,1,pos('/',EUR));
 Delete(EUR,1,pos(',',EUR));
 Delete(EUR,pos(',',EUR),20);
 Delete(AFS,1,pos('/',AFS));
 Delete(AFS,1,pos(',',AFS));
 Delete(AFS,pos(',',AFS),20);
 Label1.Caption:='Курс валют на '+DateToStr(Now)+': '+#10#13+#10#13+'  Доллар США: '+USD+#10#13+'  Евро: '+EUR+#10#13+'  Английский фунт стерлингов: '+AFS;
 // Погода
 P:=S.IndexOf('#---- Погода в городах России и СНГ ----');
 //
 if not (P=-1)
 then
  begin
   for i:=0 to 5 do
    begin
     inc(P);
     if Pos('Погода,Москва',S.Strings[p])>0
     then pM:=S.Strings[p];
     if Pos('Погода,С-Петербург',S.Strings[p])>0
     then pP:=S.Strings[p];
    end;
   // Погода,Москва,17/11,-4...-2,Москва
   // Погода,С-Петербург,17/11,-4...-2,С-Петербург
  end;
 HTTP.Free;
 Delete(pM,1,pos('/',pM));
 Delete(pM,1,pos(',',pM));
 Delete(pM,pos(',',pM),20);
 Delete(pP,1,pos('/',pP));
 Delete(pP,1,pos(',',pP));
 Delete(pP,pos(',',pP),20);
 Label1.Caption:=Label1.Caption+#10#13+#10#13+'Погода на: '+DateToStr(Now)+': '+#10#13+#10#13+'  Москва: '+pM+#10#13+'  Санкт-Петербург: '+pP;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 Label1.Caption:='Курс валют/погода на '+DateToStr(Date)+':';
end;

end.
