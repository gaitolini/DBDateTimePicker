unit DBDateTimePicker;

interface

uses
  System.SysUtils, System.Classes, Vcl.Controls,Winapi.Windows,Vcl.StdCtrls, Vcl.Mask, Vcl.Dialogs,
  Vcl.DBCtrls, Vcl.Graphics, Vcl.Buttons, Vcl.ComCtrls, System.DateUtils,
  Vcl.ExtCtrls;

type
  TDBDateTimePicker = class(TDBEdit)
  private
    FButton: TSpeedButton;
    FCalendar: TMonthCalendar;
    FTimer: TTimer;
    FMinDate: TDate;
    FMaxDate: TDate;
    FIntervalCalendar: Cardinal;
    procedure ButtonClick(Sender: TObject);
    function DoStoreMaxDate: Boolean;
    procedure SetMaxDate(const Value: TDate);
    function DoStoreMinDate: Boolean;
    procedure SetMinDate(const Value: TDate);
    procedure MonthCalendarClick(Sender: TObject);
    procedure OnTimer(Sender: TObject);
    procedure OnMouseLeaveCalendar(Sender: TObject);
    procedure OnMouseEnterCalendar(Sender: TObject);
    procedure MonthCalendarDblClick(Sender: TObject);
    function setIntervalCalendar: Cardinal;
  protected
    procedure CreateWnd; override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property MaxDate: TDate read FMaxDate write SetMaxDate stored DoStoreMaxDate;
    property MinDate: TDate read FMinDate write SetMinDate stored DoStoreMinDate;
    property IntervalCalendar: Cardinal read setIntervalCalendar write FIntervalCalendar;
  end;



procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('Data Controls', [TDBDateTimePicker]);
end;

{ TDBDateTimePicker }

constructor TDBDateTimePicker.Create(AOwner: TComponent);
begin
  inherited;
//  EditMask := '!99/99/0000;1;_';
  Text := '';
  IntervalCalendar := 2000;
  FButton := TSpeedButton.Create(Self);
  FButton.Parent := Self;
  FButton.Width := 20; // Define a largura do botão
  FButton.Height := Self.Height; // Define a altura do botão igual à altura do edit
  FButton.Caption := '..';
  FButton.Align := alRight;
  FButton.Visible := True;
  FButton.onClick :=  ButtonClick;

  FCalendar := TMonthCalendar.Create(Self);
  FCalendar.Visible := False;
  FCalendar.Parent  := Self;
  FCalendar.Width   := 200;   // Definir a largura
  FCalendar.Height  := 150;  // Definir a altura
  FCalendar.Enabled := True;
  FCalendar.DoubleBuffered := True;
  FCalendar.SetDesignVisible(True);
  FCalendar.OnClick := MonthCalendarClick;
  FCalendar.OnClick := MonthCalendarClick;
  FCalendar.OnDblClick :=  MonthCalendarDblClick;
  FCalendar.OnMouseEnter := OnMouseEnterCalendar;
  FCalendar.OnMouseLeave := OnMouseLeaveCalendar;

  FTimer := TTimer.Create(Self);
  FTimer.Enabled := False;
  FTimer.Interval := 2000;
  FTimer.OnTimer := OnTimer;

end;

destructor TDBDateTimePicker.Destroy;
begin
  FButton.Free;
  inherited;
end;

function TDBDateTimePicker.DoStoreMaxDate: Boolean;
begin
  Result := True;
  FMaxDate := FCalendar.MaxDate;
end;

function TDBDateTimePicker.DoStoreMinDate: Boolean;
begin
  Result := True;
  FMinDate := FCalendar.MinDate;
end;

procedure TDBDateTimePicker.SetMaxDate(const Value: TDate);
begin
  FMaxDate := Value;
end;

procedure TDBDateTimePicker.SetMinDate(const Value: TDate);
begin
  FMinDate := Value;
end;

procedure TDBDateTimePicker.CreateWnd;
begin
  inherited;
  // Posiciona o botão dentro do edit
  FButton.Left := Self.Width - FButton.Width;
  FButton.Top := 0;
end;

procedure TDBDateTimePicker.ButtonClick(Sender: TObject);
begin
  FCalendar.Left := Self.Left;
  FCalendar.Top := Self.Top + Self.Height;
  FCalendar.ShowTodayCircle := True;

  if Assigned(DataSource) then
  begin
    if Self.DataSource.DataSet.FieldByName(DataField).IsNull then
      FCalendar.Date := Now
    else
      FCalendar.Date := DateOf(Self.DataSource.DataSet.FieldByName(DataField).AsDateTime);
  end;

  FCalendar.Parent := Self.Parent;
  FCalendar.BringToFront;
  FCalendar.Visible := not FCalendar.Visible;

end;

procedure TDBDateTimePicker.MonthCalendarClick(Sender: TObject);
begin

  if  DataSource.DataSet.CanModify then
    DataSource.DataSet.Edit;

   DataSource.DataSet.FieldByName(DataField).AsDateTime := FCalendar.Date;

end;

procedure TDBDateTimePicker.MonthCalendarDblClick(Sender: TObject);
begin
   FCalendar.Visible := false;

  if  DataSource.DataSet.CanModify then
    DataSource.DataSet.Edit;

   DataSource.DataSet.FieldByName(DataField).AsDateTime := FCalendar.Date;

end;


procedure TDBDateTimePicker.OnMouseEnterCalendar(Sender: TObject);
begin
  FTimer.Enabled := False;
end;

procedure TDBDateTimePicker.OnMouseLeaveCalendar(Sender: TObject);
begin
  FTimer.Interval := IntervalCalendar;
  FTimer.Enabled := True;
end;

procedure TDBDateTimePicker.OnTimer(Sender: TObject);
begin
  FCalendar.Visible := False;

end;

function TDBDateTimePicker.setIntervalCalendar: Cardinal;
begin
  Result := FIntervalCalendar;
  FTimer.Interval := FIntervalCalendar;
end;

end.

