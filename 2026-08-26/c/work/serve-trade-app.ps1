param(
  [int]$Port = 8080,
  [string]$SiteFile = 'C:\Users\crois\Documents\Codex\2026-08-26\c\outputs\trade-guilds-early-india.html'
)

$listener = [System.Net.Sockets.TcpListener]::new([System.Net.IPAddress]::Any, $Port)
$listener.Start()
Write-Output "Trade & Guilds server listening on port $Port"

try {
  while ($true) {
    $client = $listener.AcceptTcpClient()
    $stream = $client.GetStream()
    # Read the request once, then reply immediately. This avoids mobile browsers
    # waiting on persistent HTTP connections before receiving the page.
    $requestBuffer = New-Object byte[] 4096
    $null = $stream.Read($requestBuffer, 0, $requestBuffer.Length)
    $bytes = [System.IO.File]::ReadAllBytes($SiteFile)
    $headers = "HTTP/1.1 200 OK`r`nContent-Type: text/html; charset=utf-8`r`nContent-Length: $($bytes.Length)`r`nCache-Control: no-store`r`nConnection: close`r`n`r`n"
    $headerBytes = [System.Text.Encoding]::ASCII.GetBytes($headers)
    $stream.Write($headerBytes, 0, $headerBytes.Length)
    $stream.Write($bytes, 0, $bytes.Length)
    $stream.Close()
    $client.Close()
  }
}
finally {
  $listener.Stop()
}
