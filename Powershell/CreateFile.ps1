$f = new-object System.IO.FileStream c:\users\vadams\desktop\test.dat, Create, ReadWrite
$f.SetLength(5MB)
$f.Close()