<?php
$data_dir = __DIR__ . '/../output/';
$session = $_GET['session'] ?? date('Y-m-d');

if (!file_exists($data_dir)) {
    die("No data found");
}

if (isset($_GET['export'])) {
    $all_data = [];
    $files = glob($data_dir . '*.txt');
    foreach ($files as $file) {
        $all_data[basename($file)] = file_get_contents($file);
    }
    header('Content-Type: application/json');
    header('Content-Disposition: attachment; filename="darkweave_export.json"');
    echo json_encode($all_data, JSON_PRETTY_PRINT);
    exit;
}
?>
