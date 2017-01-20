#Set The console to a bigger window
$console = $host.ui.RawUI
$buffer = $console.BufferSize
$buffer.width = 150
$buffer.height = 2000
$console.BufferSize = $buffer
$size = $console.WindowSize
$size.width = 150
$size.height = 80
$console.WindowSize = $size
