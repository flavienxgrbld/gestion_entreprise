// Navigation active state
document.addEventListener('DOMContentLoaded', function() {
    const navLinks = document.querySelectorAll('.nav-link');
    
    navLinks.forEach(link => {
        link.addEventListener('click', function(e) {
            // Remove active class from all nav items
            document.querySelectorAll('.nav-item').forEach(item => {
                item.classList.remove('active');
            });
            
            // Add active class to clicked item
            this.parentElement.classList.add('active');
        });
    });
    
    // Refresh button functionality
    const refreshBtn = document.querySelector('.btn-primary');
    if (refreshBtn && refreshBtn.textContent.includes('Rafraîchir')) {
        refreshBtn.addEventListener('click', function() {
            this.textContent = 'Actualisation...';
            this.disabled = true;
            
            // Simulate refresh
            setTimeout(() => {
                this.textContent = 'Rafraîchir';
                this.disabled = false;
                showNotification('Données actualisées avec succès', 'success');
            }, 1500);
        });
    }
    
    // Export button functionality
    const exportBtn = document.querySelector('.btn-secondary');
    if (exportBtn && exportBtn.textContent.includes('Exporter')) {
        exportBtn.addEventListener('click', function() {
            showNotification('Export en cours...', 'info');
            setTimeout(() => {
                showNotification('Données exportées avec succès', 'success');
            }, 1000);
        });
    }
    
    // Quick action buttons
    const actionButtons = document.querySelectorAll('.action-btn');
    actionButtons.forEach(button => {
        button.addEventListener('click', function() {
            const actionText = this.querySelector('span:last-child').textContent;
            showNotification(`Action: ${actionText}`, 'info');
        });
    });
    
    // System status update (demo)
    updateSystemStatus();
});

// Notification system
function showNotification(message, type = 'info') {
    const notification = document.createElement('div');
    notification.style.position = 'fixed';
    notification.style.top = '20px';
    notification.style.right = '20px';
    notification.style.padding = '1rem 1.5rem';
    notification.style.borderRadius = '8px';
    notification.style.color = 'white';
    notification.style.fontWeight = '500';
    notification.style.zIndex = '1000';
    notification.style.animation = 'slideIn 0.3s ease';
    
    switch(type) {
        case 'success':
            notification.style.background = '#27ae60';
            break;
        case 'error':
            notification.style.background = '#e74c3c';
            break;
        case 'info':
        default:
            notification.style.background = '#3498db';
    }
    
    notification.textContent = message;
    document.body.appendChild(notification);
    
    setTimeout(() => {
        notification.style.animation = 'slideOut 0.3s ease';
        setTimeout(() => {
            document.body.removeChild(notification);
        }, 300);
    }, 3000);
}

// Update system status (demo)
function updateSystemStatus() {
    const statusIndicator = document.querySelector('.status-indicator');
    const statusText = document.querySelector('.system-status span:last-child');
    
    if (statusIndicator && statusText) {
        // Simulate status check
        const isOnline = Math.random() > 0.1; // 90% online
        
        if (isOnline) {
            statusIndicator.classList.add('online');
            statusText.textContent = 'Système opérationnel';
        } else {
            statusIndicator.classList.remove('online');
            statusIndicator.style.backgroundColor = '#e74c3c';
            statusText.textContent = 'Maintenance en cours';
        }
    }
}

// Add CSS animations
const style = document.createElement('style');
style.textContent = `
    @keyframes slideIn {
        from {
            transform: translateX(400px);
            opacity: 0;
        }
        to {
            transform: translateX(0);
            opacity: 1;
        }
    }
    
    @keyframes slideOut {
        from {
            transform: translateX(0);
            opacity: 1;
        }
        to {
            transform: translateX(400px);
            opacity: 0;
        }
    }
`;
document.head.appendChild(style);
