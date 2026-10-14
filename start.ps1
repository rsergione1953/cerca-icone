$ErrorActionPreference = "Stop"
$root = [System.IO.Path]::GetFullPath($PSScriptRoot)
$rootPrefix = $root.TrimEnd([System.IO.Path]::DirectorySeparatorChar) + [System.IO.Path]::DirectorySeparatorChar
$allowedFiles = @("index.html", "manifest.webmanifest", "app-icon.svg", "app-icon-192.png", "app-icon-512.png", "sw.js")
$address = "http://127.0.0.1:8765/"
$listener = New-Object System.Net.HttpListener
$listener.Prefixes.Add($address)

try {
    $listener.Start()
} catch {
    Write-Host "Non riesco ad avviare il server su $address. Potrebbe esserci gia' un'altra app in esecuzione." -ForegroundColor Red
    Write-Host $_.Exception.Message -ForegroundColor DarkRed
    Read-Host "Premi Invio per chiudere"
    exit 1
}

Write-Host "Cerca Icone e' disponibile su $address" -ForegroundColor Green
Write-Host "Lascia aperta questa finestra mentre usi l'app. Premi Ctrl+C per fermarla."
Start-Process $address

try {
    while ($listener.IsListening) {
        $context = $listener.GetContext()
        $response = $context.Response
        try {
            if ($context.Request.HttpMethod -ne "GET" -and $context.Request.HttpMethod -ne "HEAD") {
                $response.StatusCode = 405
                $response.Headers["Allow"] = "GET, HEAD"
            } else {
                $relativePath = [Uri]::UnescapeDataString($context.Request.Url.AbsolutePath.TrimStart("/"))
                if ([string]::IsNullOrWhiteSpace($relativePath)) {
                    $relativePath = "index.html"
                }
                $filePath = [System.IO.Path]::GetFullPath((Join-Path $root $relativePath))
                if ($allowedFiles -notcontains $relativePath -or -not $filePath.StartsWith($rootPrefix, [System.StringComparison]::OrdinalIgnoreCase) -or -not (Test-Path -LiteralPath $filePath -PathType Leaf)) {
                    $response.StatusCode = 404
                } else {
                    $extension = [System.IO.Path]::GetExtension($filePath).ToLowerInvariant()
                    switch ($extension) {
                        ".html" { $contentType = "text/html; charset=utf-8" }
                        ".webmanifest" { $contentType = "application/manifest+json; charset=utf-8" }
                        ".svg" { $contentType = "image/svg+xml; charset=utf-8" }
                        ".png" { $contentType = "image/png" }
                        ".js" { $contentType = "application/javascript; charset=utf-8" }
                        default { $contentType = "application/octet-stream" }
                    }
                    $bytes = [System.IO.File]::ReadAllBytes($filePath)
                    $response.ContentType = $contentType
                    $response.Headers["Cache-Control"] = "no-cache"
                    $response.Headers["X-Content-Type-Options"] = "nosniff"
                    $response.ContentLength64 = $bytes.Length
                    if ($context.Request.HttpMethod -eq "GET") {
                        $response.OutputStream.Write($bytes, 0, $bytes.Length)
                    }
                }
            }
        } catch {
            Write-Host "Errore durante la risposta HTTP: $($_.Exception.Message)" -ForegroundColor Red
            $response.StatusCode = 500
        } finally {
            $response.Close()
        }
    }
} finally {
    if ($listener.IsListening) {
        $listener.Stop()
    }
    $listener.Close()
}
