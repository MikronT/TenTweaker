if WScript.Arguments.Count > 1 then
  Set Args = WScript.Arguments

  Dim Command
  For i = 1 to Args.Count - 1
    Command=Command & " """ & Args(i) & """ "
  Next

  CreateObject("WScript.Shell").CurrentDirectory = Args(0)
  CreateObject("Shell.Application").ShellExecute "cmd.exe", "/c ""pushd " & Args(0) & " & " & Command & """", "", "runas", 1
end if