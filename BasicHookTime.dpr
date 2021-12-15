library BasicHookTime;

uses
  Windows;

procedure FakeGeSystemTime(out SytemTime: SYSTEMTIME); stdcall;
begin
  SytemTime.wYear := 2222;
  SytemTime.wMonth := 11;
  SytemTime.wDay := 11;
  SytemTime.wHour := 11;
  SytemTime.wMinute := 11;
  SytemTime.wSecond := 11;
  SytemTime.wMilliseconds := 1111;
end;

// --- 64bit
type
  TDataToWrite = packed record
    MOV: WORD;
    FakeProc: Pointer;
    JMPEAX: WORD end;

    (*
      //--- 32bit
      type
      TDataToWrite = packed record
      MOV: BYTE;
      FakeProc: Pointer;
      JMPEAX: WORD
      end;
    *)

  var
    lpNumberOfBytesWritten: SIZE_T;
	DataToWrite: TDataToWrite;
    pGetSystemTime: Pointer;
    pGetLocalTime: Pointer;

  begin

    // --- 64bit
    DataToWrite.MOV := $B848;

    // --- 32bit
    // DataToWrite.MOV := $B8;

    DataToWrite.FakeProc := @FakeGeSystemTime;
    DataToWrite.JMPEAX := $E0FF;

    pGetSystemTime := GetProcAddress(GetModuleHandleA('kernel32.dll'),
      'GetSystemTime');

    WriteProcessMemory(GetCurrentProcess(), pGetSystemTime, @DataToWrite,
      sizeof(DataToWrite), lpNumberOfBytesWritten);

    pGetLocalTime := GetProcAddress(GetModuleHandleA('kernel32.dll'),
      'GetLocalTime');

    WriteProcessMemory(GetCurrentProcess(), pGetLocalTime, @DataToWrite,
      sizeof(DataToWrite), lpNumberOfBytesWritten);

end.
