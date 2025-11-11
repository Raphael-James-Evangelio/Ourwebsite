// Our Journey Love Story - Interactive JavaScript

document.addEventListener('DOMContentLoaded', function() {
    document.documentElement.classList.add('js-enabled');
    initializeLightbox();
    initializeSmoothScrolling();
    initializeAnimations();
    initializeMusicPlayer();
    initializeGalleryEffects();
    initializeHeroParallax();
    initializeTimelineProgress();
    initializeBackgroundOrbs();
});

function initializeLightbox() {
    const galleryItems = Array.from(document.querySelectorAll('.gallery-item'));
    const modalElement = document.getElementById('lightboxModal');
    if (!modalElement || galleryItems.length === 0) return;

    const lightboxModal = new bootstrap.Modal(modalElement);
    const lightboxImage = document.getElementById('lightboxImage');
    const prevBtn = document.getElementById('lightboxPrev');
    const nextBtn = document.getElementById('lightboxNext');
    const galleryImages = galleryItems.map(item => item.querySelector('.gallery-img')).filter(Boolean);
    let currentIndex = 0;

    const updateLightboxImage = (index) => {
        const img = galleryImages[index];
        if (!img) return;
        lightboxImage.src = img.src;
        lightboxImage.alt = img.alt || 'Captured memory';
        lightboxImage.style.opacity = '0';
        requestAnimationFrame(() => {
            lightboxImage.style.transition = 'opacity 300ms ease';
            lightboxImage.style.opacity = '1';
        });
    };

    const showPrev = () => {
        currentIndex = (currentIndex - 1 + galleryImages.length) % galleryImages.length;
        updateLightboxImage(currentIndex);
    };

    const showNext = () => {
        currentIndex = (currentIndex + 1) % galleryImages.length;
        updateLightboxImage(currentIndex);
    };

    galleryItems.forEach((item, index) => {
        item.addEventListener('click', function() {
            currentIndex = index;
            updateLightboxImage(currentIndex);
            lightboxModal.show();
        });
    });

    prevBtn?.addEventListener('click', (e) => {
        e.stopPropagation();
        showPrev();
    });

    nextBtn?.addEventListener('click', (e) => {
        e.stopPropagation();
        showNext();
    });

    modalElement.addEventListener('click', function(e) {
        if (e.target === this) {
            lightboxModal.hide();
        }
    });

    document.addEventListener('keydown', function(e) {
        if (!modalElement.classList.contains('show')) return;
        if (e.key === 'ArrowLeft') {
            showPrev();
        } else if (e.key === 'ArrowRight') {
            showNext();
        } else if (e.key === 'Escape') {
            lightboxModal.hide();
        }
    });
}

function initializeSmoothScrolling() {
    const navLinks = document.querySelectorAll('.nav-link[href^="#"]');

    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            const targetId = this.getAttribute('href').substring(1);
            const targetElement = document.getElementById(targetId);
            if (!targetElement) return;

            e.preventDefault();
            const navbarHeight = document.querySelector('.navbar')?.offsetHeight || 70;
            const offsetTop = targetElement.getBoundingClientRect().top + window.pageYOffset - navbarHeight + 6;

            window.scrollTo({
                top: offsetTop,
                behavior: 'smooth'
            });

            const navbarCollapse = document.querySelector('.navbar-collapse');
            if (navbarCollapse?.classList.contains('show')) {
                new bootstrap.Collapse(navbarCollapse).hide();
            }
        });
    });
}

function initializeAnimations() {
    const revealElements = document.querySelectorAll('.reveal');

    if (!('IntersectionObserver' in window)) {
        revealElements.forEach(section => section.classList.add('fade-in'));
        return;
    }

    const observerOptions = {
        threshold: 0.2,
        rootMargin: '0px 0px -80px 0px'
    };

    const observer = new IntersectionObserver((entries, obs) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                entry.target.classList.add('fade-in');
                if (entry.target.classList.contains('timeline-item')) {
                    entry.target.classList.add('timeline-item-active');
                }
                obs.unobserve(entry.target);
            }
        });
    }, observerOptions);

    revealElements.forEach(section => observer.observe(section));
    document.querySelectorAll('.gallery-item').forEach(item => observer.observe(item));
    document.querySelectorAll('.timeline-item').forEach(item => observer.observe(item));

    requestAnimationFrame(() => {
        revealElements.forEach(section => {
            const rect = section.getBoundingClientRect();
            if (rect.top <= window.innerHeight * 0.9) {
                section.classList.add('fade-in');
            }
        });
    });
}

function initializeGalleryEffects() {
    const galleryItems = document.querySelectorAll('.gallery-item');

    galleryItems.forEach(item => {
        item.addEventListener('mouseenter', function(e) {
            const img = this.querySelector('.gallery-img');
            if (!img) return;
            const rect = this.getBoundingClientRect();
            const centerX = rect.left + rect.width / 2;
            const centerY = rect.top + rect.height / 2;
            const rotateY = (e.clientX - centerX) / 40;
            const rotateX = (centerY - e.clientY) / 40;
            img.style.transform = `scale(1.05) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
        });

        item.addEventListener('mousemove', function(e) {
            const img = this.querySelector('.gallery-img');
            if (!img) return;
            const rect = this.getBoundingClientRect();
            const centerX = rect.left + rect.width / 2;
            const centerY = rect.top + rect.height / 2;
            const rotateY = (e.clientX - centerX) / 40;
            const rotateX = (centerY - e.clientY) / 40;
            img.style.transform = `scale(1.05) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
        });

        item.addEventListener('mouseleave', function() {
            const img = this.querySelector('.gallery-img');
            if (!img) return;
            img.style.transform = '';
        });
    });
}

function initializeMusicPlayer() {
    const playBtn = document.getElementById('playMusicBtn');
    if (!playBtn) return;

    playBtn.addEventListener('click', function() {
        removeMusicNotes();
    });
}

function createMusicNotes() {
    const container = document.querySelector('.playlist-card');
    if (!container) return;

    const notes = ['♪', '♫', '♬'];

    for (let i = 0; i < 10; i++) {
        setTimeout(() => {
            const note = document.createElement('div');
            note.textContent = notes[Math.floor(Math.random() * notes.length)];
            note.classList.add('floating-note');
            note.style.color = getComputedStyle(document.documentElement).getPropertyValue('--rosewood') || '#8d5a5a';
            note.style.fontSize = `${18 + Math.random() * 18}px`;
            note.style.left = `${Math.random() * 100}%`;
            container.appendChild(note);

            setTimeout(() => note.remove(), 5000);
        }, i * 250);
    }
}

function removeMusicNotes() {
    document.querySelectorAll('.floating-note').forEach(node => node.remove());
}

function initializeHeroParallax() {
    const collage = document.querySelector('.hero-collage');
    if (!collage || !window.matchMedia('(pointer: fine)').matches) return;

    const handleMove = (e) => {
        const rect = collage.getBoundingClientRect();
        const offsetX = e.clientX - (rect.left + rect.width / 2);
        const offsetY = e.clientY - (rect.top + rect.height / 2);
        const rotateX = (offsetY / rect.height) * -12;
        const rotateY = (offsetX / rect.width) * 12;

        collage.style.transform = `perspective(1200px) rotateX(${rotateX}deg) rotateY(${rotateY}deg)`;
        collage.classList.add('is-tilting');
    };

    const reset = () => {
        collage.style.transform = '';
        collage.classList.remove('is-tilting');
    };

    collage.addEventListener('mousemove', handleMove);
    collage.addEventListener('mouseleave', reset);
}

function initializeTimelineProgress() {
    const timeline = document.querySelector('.timeline');
    const progressFill = document.querySelector('.timeline-progress-fill');
    const items = Array.from(document.querySelectorAll('.timeline-item'));
    if (!timeline || !progressFill || items.length === 0) return;

    const update = () => {
        const rect = timeline.getBoundingClientRect();
        const start = rect.top + window.scrollY;
        const height = rect.height;
        const viewportMid = window.scrollY + window.innerHeight * 0.45;
        let progress = (viewportMid - start) / height;
        progress = Math.min(Math.max(progress, 0), 1);
        progressFill.style.height = `${progress * 100}%`;

        items.forEach(item => {
            const itemCenter = item.getBoundingClientRect().top + window.scrollY + item.offsetHeight / 2;
            if (viewportMid >= itemCenter) {
                item.classList.add('timeline-item-active');
            } else {
                item.classList.remove('timeline-item-active');
            }
        });
    };

    update();
    window.addEventListener('scroll', update, { passive: true });
    window.addEventListener('resize', update);
}

function initializeBackgroundOrbs() {
    const orbs = document.querySelectorAll('.background-orb');
    if (orbs.length === 0) return;

    const dampen = [18, 26, 34];

    window.addEventListener('mousemove', (event) => {
        const { innerWidth, innerHeight } = window;
        const offsetX = (event.clientX / innerWidth - 0.5) * 40;
        const offsetY = (event.clientY / innerHeight - 0.5) * 30;

        orbs.forEach((orb, index) => {
            const factor = dampen[index] || 24;
            orb.style.setProperty('--translate-x', `${offsetX / factor}%`);
            orb.style.setProperty('--translate-y', `${offsetY / factor}%`);
        });
    });
}

const musicStyles = document.createElement('style');
musicStyles.textContent = `
    @keyframes floatUp {
        0% { transform: translateY(0) translateX(0); opacity: 0; }
        30% { opacity: 0.8; }
        100% { transform: translateY(-160px) translateX(-30px); opacity: 0; }
    }
`;
document.head.appendChild(musicStyles);

window.addEventListener('resize', function() {
    // Reserved for future responsive hooks
});

window.addEventListener('load', function() {
    document.body.classList.add('loaded');
});

document.querySelectorAll('img').forEach(img => {
    img.addEventListener('error', function() {
        this.src = 'data:image/svg+xml;base64,PHN2ZyB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgeG1sbnM9Imh0dHA6Ly93d3cudzMub3JnLzIwMDAvc3ZnIj48cmVjdCB3aWR0aD0iMjAwIiBoZWlnaHQ9IjIwMCIgZmlsbD0iI2Y2ZDc0ZSIvPjx0ZXh0IHg9IjUwJSIgeT0iNTAlIiBmb250LWZhbWlseT0iTnVuaXRvIiBmb250LXNpemU9IjE2IiBmaWxsPSIjOGQ1YTVhIiB0ZXh0LWFuY2hvcj0ibWlkZGxlIiBkeT0iLjNlbSI+SW1hZ2UgTm90IEZvdW5kPC90ZXh0Pjwvc3ZnPg==' ;
        this.alt = 'Image not found';
    });
});

if ('IntersectionObserver' in window) {
    const imageObserver = new IntersectionObserver((entries, observer) => {
        entries.forEach(entry => {
            if (entry.isIntersecting) {
                const img = entry.target;
                if (img.dataset.src) {
                    img.src = img.dataset.src;
                    img.removeAttribute('data-src');
                }
                observer.unobserve(img);
            }
        });
    });

    document.querySelectorAll('img[data-src]').forEach(img => {
        imageObserver.observe(img);
    });
}

console.log('%cOur Journey Love Story', 'color: #8d5a5a; font-size: 16px; font-weight: bold;');
console.log('%cA scrapbook of moments, promises, and the everyday magic we share.', 'color: #2f2530; font-size: 12px;');
