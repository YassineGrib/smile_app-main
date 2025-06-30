document.addEventListener('DOMContentLoaded', function() {
    const typedTextSpan = document.querySelector('.typed-text');
    const cursorSpan = document.querySelector('.cursor');

    const textArray = ["Your Child.", "Your Peace of Mind.", "the Future.", "Your Family."];
    const typingDelay = 100;
    const erasingDelay = 50;
    const newTextDelay = 2000; // Delay between current and next text
    let textArrayIndex = 0;
    let charIndex = 0;

    function type() {
        if (charIndex < textArray[textArrayIndex].length) {
            if(!cursorSpan.classList.contains('typing')) cursorSpan.classList.add('typing');
            typedTextSpan.textContent += textArray[textArrayIndex].charAt(charIndex);
            charIndex++;
            setTimeout(type, typingDelay);
        } else {
            cursorSpan.classList.remove('typing');
            setTimeout(erase, newTextDelay);
        }
    }

    function erase() {
        if (charIndex > 0) {
            if(!cursorSpan.classList.contains('typing')) cursorSpan.classList.add('typing');
            typedTextSpan.textContent = textArray[textArrayIndex].substring(0, charIndex - 1);
            charIndex--;
            setTimeout(erase, erasingDelay);
        } else {
            cursorSpan.classList.remove('typing');
            textArrayIndex++;
            if (textArrayIndex >= textArray.length) textArrayIndex = 0;
            setTimeout(type, typingDelay + 1100);
        }
    }

    if (textArray.length) setTimeout(type, newTextDelay + 250);

    // Floating Icons in Hero Section
    function createFloatingIcons() {
        const iconContainer = document.querySelector('.hero-icons');
        if (!iconContainer) return;

        const icons = ['☀️', '☁️', '🍼', '🧸', '🚀', '🎈', '⭐', '❤️', '😊'];
        const count = 10; // Number of icons to create

        for(let i = 0; i < count; i++) {
            const icon = document.createElement('i');
            icon.innerText = icons[Math.floor(Math.random() * icons.length)];
            icon.style.left = `${Math.random() * 95 + 2}%`; // Random horizontal position
            icon.style.animationDelay = `${Math.random() * 10}s`;
            icon.style.animationDuration = `${Math.random() * 10 + 15}s`; // Duration between 15s and 25s
            icon.style.fontSize = `${Math.random() * 2 + 1.5}rem`; // Size between 1.5rem and 3.5rem

            iconContainer.appendChild(icon);
        }
    }
    
    createFloatingIcons();
}); 