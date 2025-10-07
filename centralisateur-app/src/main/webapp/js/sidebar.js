/**
 * Sidebar Management JavaScript
 * Gère toutes les interactions et animations de la sidebar
 */

class SidebarManager {
    constructor() {
        this.sidebar = document.getElementById('sidebar');
        this.mainContent = document.getElementById('mainContent');
        this.sidebarToggle = document.getElementById('sidebarToggle');
        this.overlay = null;
        
        // État de la sidebar (récupéré du localStorage)
        this.sidebarCollapsed = localStorage.getItem('sidebarCollapsed') === 'true';
        this.isMobile = window.innerWidth <= 768;
        
        this.init();
    }
    
    init() {
        this.createOverlay();
        this.applyInitialState();
        this.bindEvents();
        this.initAnimations();
        this.handleResize();
    }
    
    createOverlay() {
        // Créer l'overlay pour mobile
        this.overlay = document.createElement('div');
        this.overlay.className = 'sidebar-overlay';
        this.overlay.style.cssText = `
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background: rgba(0, 0, 0, 0.5);
            z-index: 999;
            opacity: 0;
            visibility: hidden;
            transition: all 0.3s ease;
        `;
        document.body.appendChild(this.overlay);
        
        // Fermer la sidebar en cliquant sur l'overlay
        this.overlay.addEventListener('click', () => {
            this.hideSidebar();
        });
    }
    
    applyInitialState() {
        if (this.isMobile) {
            // Sur mobile, la sidebar est cachée par défaut
            this.sidebar.classList.remove('collapsed');
            this.mainContent.classList.remove('expanded');
            this.sidebar.style.transform = 'translateX(-100%)';
        } else {
            // Sur desktop, appliquer l'état sauvegardé
            if (this.sidebarCollapsed) {
                this.sidebar.classList.add('collapsed');
                this.mainContent.classList.add('expanded');
            }
        }
    }
    
    bindEvents() {
        // Toggle de la sidebar
        if (this.sidebarToggle) {
            this.sidebarToggle.addEventListener('click', (e) => {
                e.preventDefault();
                this.toggleSidebar();
            });
        }
        
        // Gestion du redimensionnement
        window.addEventListener('resize', () => {
            this.handleResize();
        });
        
        // Navigation active
        this.updateActiveNavigation();
        
        // Gestion des tooltips sur sidebar collapsed
        this.initTooltips();
        
        // Fermer la sidebar avec Escape sur mobile
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && this.isMobile && this.sidebar.classList.contains('show')) {
                this.hideSidebar();
            }
        });
    }
    
    toggleSidebar() {
        if (this.isMobile) {
            // Sur mobile, show/hide
            if (this.sidebar.classList.contains('show')) {
                this.hideSidebar();
            } else {
                this.showSidebar();
            }
        } else {
            // Sur desktop, collapse/expand
            this.sidebarCollapsed = !this.sidebarCollapsed;
            
            if (this.sidebarCollapsed) {
                this.sidebar.classList.add('collapsed');
                this.mainContent.classList.add('expanded');
            } else {
                this.sidebar.classList.remove('collapsed');
                this.mainContent.classList.remove('expanded');
            }
            
            // Sauvegarder l'état
            localStorage.setItem('sidebarCollapsed', this.sidebarCollapsed);
            
            // Déclencher un événement personnalisé
            this.dispatchSidebarEvent('toggle', { collapsed: this.sidebarCollapsed });
        }
    }
    
    showSidebar() {
        this.sidebar.classList.add('show');
        this.sidebar.style.transform = 'translateX(0)';
        this.overlay.style.opacity = '1';
        this.overlay.style.visibility = 'visible';
        document.body.style.overflow = 'hidden';
        
        this.dispatchSidebarEvent('show');
    }
    
    hideSidebar() {
        this.sidebar.classList.remove('show');
        this.sidebar.style.transform = 'translateX(-100%)';
        this.overlay.style.opacity = '0';
        this.overlay.style.visibility = 'hidden';
        document.body.style.overflow = '';
        
        this.dispatchSidebarEvent('hide');
    }
    
    handleResize() {
        const wasMobile = this.isMobile;
        this.isMobile = window.innerWidth <= 768;
        
        if (wasMobile !== this.isMobile) {
            // Transition mobile <-> desktop
            if (this.isMobile) {
                // Passage en mobile
                this.sidebar.classList.remove('collapsed');
                this.mainContent.classList.remove('expanded');
                this.sidebar.style.transform = 'translateX(-100%)';
                this.hideSidebar();
            } else {
                // Passage en desktop
                this.sidebar.classList.remove('show');
                this.sidebar.style.transform = '';
                this.overlay.style.opacity = '0';
                this.overlay.style.visibility = 'hidden';
                document.body.style.overflow = '';
                
                // Restaurer l'état collapsed sur desktop
                if (this.sidebarCollapsed) {
                    this.sidebar.classList.add('collapsed');
                    this.mainContent.classList.add('expanded');
                }
            }
        }
    }
    
    updateActiveNavigation() {
        // Mettre à jour les liens actifs basés sur l'URL actuelle
        const currentPath = window.location.pathname;
        const navLinks = this.sidebar.querySelectorAll('.nav-link');
        
        navLinks.forEach(link => {
            const href = link.getAttribute('href');
            link.classList.remove('active');
            
            if (href && (currentPath === href || currentPath.startsWith(href + '/'))) {
                link.classList.add('active');
                
                // Scroller vers le lien actif si nécessaire
                setTimeout(() => {
                    this.scrollToActiveLink(link);
                }, 100);
            }
        });
        
        // Cas spécial pour la page d'accueil
        if (currentPath === '/' || currentPath.endsWith('/')) {
            const homeLink = this.sidebar.querySelector('.nav-link[href*="/"]');
            if (homeLink) {
                homeLink.classList.add('active');
            }
        }
    }
    
    scrollToActiveLink(activeLink) {
        const navContainer = this.sidebar.querySelector('.sidebar-nav');
        const linkRect = activeLink.getBoundingClientRect();
        const containerRect = navContainer.getBoundingClientRect();
        
        if (linkRect.top < containerRect.top || linkRect.bottom > containerRect.bottom) {
            activeLink.scrollIntoView({
                behavior: 'smooth',
                block: 'center'
            });
        }
    }
    
    initTooltips() {
        // Les tooltips sont gérés via CSS, mais on peut ajouter une logique supplémentaire ici
        const navLinks = this.sidebar.querySelectorAll('.nav-link[data-tooltip]');
        
        navLinks.forEach(link => {
            // Ajouter des événements pour améliorer les tooltips si nécessaire
            link.addEventListener('mouseenter', () => {
                if (this.sidebar.classList.contains('collapsed')) {
                    // Logique supplémentaire pour les tooltips
                }
            });
        });
    }
    
    initAnimations() {
        // Animation d'entrée progressive des éléments
        const navItems = this.sidebar.querySelectorAll('.nav-item');
        
        navItems.forEach((item, index) => {
            item.style.opacity = '0';
            item.style.transform = 'translateX(-20px)';
            
            setTimeout(() => {
                item.style.transition = 'all 0.3s ease';
                item.style.opacity = '1';
                item.style.transform = 'translateX(0)';
            }, 100 + (index * 50));
        });
    }
    
    dispatchSidebarEvent(type, detail = {}) {
        // Déclencher un événement personnalisé pour les autres scripts
        const event = new CustomEvent(`sidebar:${type}`, {
            detail: { ...detail, isMobile: this.isMobile }
        });
        document.dispatchEvent(event);
    }
    
    // Méthodes publiques pour l'API
    collapse() {
        if (!this.isMobile && !this.sidebarCollapsed) {
            this.toggleSidebar();
        }
    }
    
    expand() {
        if (!this.isMobile && this.sidebarCollapsed) {
            this.toggleSidebar();
        }
    }
    
    isCollapsed() {
        return this.isMobile ? false : this.sidebarCollapsed;
    }
    
    isVisible() {
        return this.isMobile ? this.sidebar.classList.contains('show') : true;
    }
}

// Initialisation automatique
document.addEventListener('DOMContentLoaded', () => {
    // Créer l'instance globale du gestionnaire de sidebar
    window.sidebarManager = new SidebarManager();
    
    // Fonction utilitaire globale pour le toggle
    window.toggleSidebar = () => {
        window.sidebarManager.toggleSidebar();
    };
});

// Gestion des liens de navigation avec animation
document.addEventListener('click', (e) => {
    const link = e.target.closest('.nav-link');
    if (link && link.getAttribute('href') && !link.getAttribute('href').startsWith('#')) {
        // Ajouter une classe de chargement
        link.classList.add('loading');
        
        // Fermer la sidebar sur mobile après clic
        if (window.sidebarManager && window.sidebarManager.isMobile) {
            setTimeout(() => {
                window.sidebarManager.hideSidebar();
            }, 150);
        }
    }
});

// Écouter les événements de la sidebar
document.addEventListener('sidebar:toggle', (e) => {
    console.log('Sidebar toggled:', e.detail);
});

document.addEventListener('sidebar:show', (e) => {
    console.log('Sidebar shown');
});

document.addEventListener('sidebar:hide', (e) => {
    console.log('Sidebar hidden');
});

// Export pour les modules ES6 si nécessaire
if (typeof module !== 'undefined' && module.exports) {
    module.exports = SidebarManager;
}