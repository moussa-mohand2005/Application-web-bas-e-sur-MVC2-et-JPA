<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Commande validée"/>
<%@ include file="layout.jspf" %>

<style>
.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2.5rem;
    padding-bottom: 1.5rem;
    border-bottom: 2px solid var(--border-color);
    text-align: center;
    flex-direction: column;
}

.success-icon {
    width: 120px;
    height: 120px;
    margin: 0 auto 2rem;
    background: linear-gradient(135deg, var(--success-color) 0%, #10b981 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 0 40px rgba(16, 185, 129, 0.4);
    animation: scaleIn 0.6s ease-out;
}

.success-icon svg {
    width: 60px;
    height: 60px;
    stroke: white;
    stroke-width: 3;
}

.success-card {
    max-width: 700px;
    margin: 0 auto;
    text-align: center;
    background: var(--card-background);
    padding: 3rem;
    border-radius: var(--radius-xl);
    box-shadow: var(--shadow-xl);
    border: 1px solid var(--border-color);
}

.detail-item {
    background: rgba(99, 102, 241, 0.05);
    padding: 1.5rem;
    border-radius: var(--radius-md);
    border-left: 4px solid var(--primary-color);
}

.detail-label {
    font-size: 0.875rem;
    color: var(--text-muted);
    margin-bottom: 0.5rem;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

.detail-value {
    font-size: 1.125rem;
    font-weight: 600;
    color: var(--text-primary);
}

.order-steps {
    display: grid;
    grid-template-columns: repeat(3, 1fr);
    gap: 2rem;
    margin: 3rem 0;
}

.step {
    text-align: center;
}

.step-number {
    width: 50px;
    height: 50px;
    margin: 0 auto 1rem;
    background: rgba(99, 102, 241, 0.15);
    border: 2px solid var(--primary-color);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    font-weight: 700;
    font-size: 1.25rem;
    color: var(--primary-light);
}

.step-title {
    font-weight: 600;
    margin-bottom: 0.5rem;
}

.step-description {
    font-size: 0.875rem;
    color: var(--text-muted);
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

.success-actions {
    display: flex;
    gap: 1rem;
    justify-content: center;
    flex-wrap: wrap;
}

@media (max-width: 640px) {
    .order-steps {
        grid-template-columns: 1fr;
    }
}
</style>

<div class="container">
    <div class="page-header">
        <div class="success-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
                <path d="M5 13l4 4L19 7"/>
            </svg>
        </div>
        <div>
            <h1 style="color: var(--success-color);">Commande validée !</h1>
            <p style="color: var(--text-muted); margin-top: 0.5rem;">Votre commande a été enregistrée avec succès</p>
        </div>
    </div>
    
    <div class="success-card">
        <div class="detail-item" style="text-align: left; margin-bottom: 2rem;">
            <div class="detail-label">Message de confirmation</div>
            <div class="detail-value">
                Merci pour votre achat. Vous recevrez bientôt un email de confirmation avec les détails de votre commande.
            </div>
        </div>
        
        <div class="order-steps">
            <div class="step">
                <div class="step-number">1</div>
                <div class="step-title">Confirmation</div>
                <div class="step-description">Email envoyé</div>
            </div>
            <div class="step">
                <div class="step-number">2</div>
                <div class="step-title">Préparation</div>
                <div class="step-description">En cours</div>
            </div>
            <div class="step">
                <div class="step-number">3</div>
                <div class="step-title">Livraison</div>
                <div class="step-description">Bientôt</div>
            </div>
        </div>
        
        <div class="success-actions">
            <a href="${pageContext.request.contextPath}/produits?action=list" class="btn btn-large">Continuer mes achats</a>
            <a href="${pageContext.request.contextPath}/panier?action=view" class="btn btn-secondary btn-large">Voir mon panier</a>
        </div>
    </div>
</div>

</main>
<footer class="footer">
    <div class="container">
        <p>&copy; 2025 E-Shop. Tous droits réservés.</p>
    </div>
</footer>
</body>
</html>
