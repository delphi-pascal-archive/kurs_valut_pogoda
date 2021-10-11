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
 // ���� �����
 P:=S.IndexOf('#---- ����� �� �� ----');
 //
 if not (P=-1)
 then
  begin
   for i:=0 to 5 do
    begin
     inc(P);
     if Pos('USD �� ��',S.Strings[p])>0
     then USD:=S.Strings[p];
     if Pos('EUR �� ��',S.Strings[p])>0
     then EUR:=S.Strings[p];
     if Pos('GBP �� ��',S.Strings[p])>0
     then AFS:=S.Strings[p];     
    end;
   // USD �� ��,1 ������ ���,27/02,31.6065,0.019
   // EUR �� ��,1 ����,27/02,34.0118,-0.1311
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
 Label1.Caption:='���� ����� �� '+DateToStr(Now)+': '+#10#13+#10#13+'  ������ ���: '+USD+#10#13+'  ����: '+EUR+#10#13+'  ���������� ���� ����������: '+AFS;
 // ������
 P:=S.IndexOf('#---- ������ � ������� ������ � ��� ----');
 //
 if not (P=-1)
 then
  begin
   for i:=0 to 5 do
    begin
     inc(P);
     if Pos('������,������',S.Strings[p])>0
     then pM:=S.Strings[p];
     if Pos('������,�-���������',S.Strings[p])>0
     then pP:=S.Strings[p];
    end;
   // ������,������,17/11,-4...-2,������
   // ������,�-���������,17/11,-4...-2,�-���������
  end;
 HTTP.Free;
 Delete(pM,1,pos('/',pM));
 Delete(pM,1,pos(',',pM));
 Delete(pM,pos(',',pM),20);
 Delete(pP,1,pos('/',pP));
 Delete(pP,1,pos(',',pP));
 Delete(pP,pos(',',pP),20);
 Label1.Caption:=Label1.Caption+#10#13+#10#13+'������ ��: '+DateToStr(Now)+': '+#10#13+#10#13+'  ������: '+pM+#10#13+'  �����-���������: '+pP;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
 Label1.Caption:='���� �����/������ �� '+DateToStr(Date)+':';
end;

end.
