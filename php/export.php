<?php
$data_dir = __DIR__ . '/../output/';

$html = '<!DOCTYPE html>
<html>
<head>
    <title>Darkweave Report</title>
    <style>
        body { font-family: monospace; background: #0a0e27; color: #0f0; padding: 20px; }
        h1 { color: #0f0; }
        pre { background: #000; padding: 10px; border: 1px solid #0f0; }
    </style>
</head>
<body>
    <h1>Darkweave Intelligence Report</h1>
    <pre>';

$files = glob($data_dir . '*.txt');
foreach ($files as $file) {
    $html .= "\n=== " . basename($file) . " ===\n";
    $html .= file_get_contents($file);
}

$html .= '</pre></body></html>';
echo $html;
?>
