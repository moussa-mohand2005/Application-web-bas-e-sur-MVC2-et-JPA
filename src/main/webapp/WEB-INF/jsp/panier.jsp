<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Mon Panier"/>
<%@ include file="layout.jspf" %>

<style>
.page-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2.5rem;
    padding-bottom: 1.5rem;
    border-bottom: 2px solid var(--border-color);
}

.page-header h1 {
    margin: 0;
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

.cart-summary {
    background: var(--card-background);
    padding: 2rem;
    border-radius: var(--radius-xl);
    margin-top: 2rem;
    border: 1px solid var(--border-color);
    box-shadow: var(--shadow-lg);
}

.summary-row {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 1rem 0;
    border-bottom: 1px solid var(--border-color);
}

.summary-row:last-child {
    border-bottom: none;
    padding-top: 1.5rem;
    font-size: 1.5rem;
    font-weight: 700;
}

.empty-state {
    text-align: center;
    padding: 4rem 2rem;
    background: var(--card-background);
    border-radius: var(--radius-xl);
    border: 2px dashed var(--border-color);
}

.empty-state h3 {
    font-size: 1.5rem;
    margin-bottom: 1rem;
    color: var(--text-secondary);
}

.cart-actions-container {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 2rem;
    padding-top: 2rem;
    border-top: 2px solid var(--border-color);
}

.action-buttons {
    display: flex;
    gap: 1rem;
}
</style>

<div class="container">
    <div class="page-header">
        <div>
            <h1>Mon Panier</h1>
            <p style="color: var(--text-muted); margin-top: 0.5rem;">Gérez vos articles avant de passer commande</p>
        </div>
    </div>
    
    <c:if test="${not empty error}">
        <div class="alert alert-error">${error}</div>
    </c:if>
    
    <c:if test="${empty panier.lignes}">
        <div class="empty-state">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5" style="width: 120px; height: 120px; margin: 0 auto 2rem; opacity: 0.5;">
                <path d="M3 3h2l.4 2M7 13h10l4-8H5.4M7 13L5.4 5M7 13l-2.293 2.293c-.63.63-.184 1.707.707 1.707H17m0 0a2 2 0 100 4 2 2 0 000-4zm-8 2a2 2 0 11-4 0 2 2 0 014 0z"/>
            </svg>
            <h3>Votre panier est vide</h3>
            <p style="margin-bottom: 2rem; color: var(--text-muted);">Commencez à ajouter des produits pour les voir apparaître ici</p>
            <a href="${pageContext.request.contextPath}/produits?action=list" class="btn btn-large">Découvrir les produits</a>
        </div>
    </c:if>
    
    <c:if test="${not empty panier.lignes}">
        <table class="cart-table">
            <thead>
                <tr>
                    <th>Produit</th>
                    <th>Prix unitaire</th>
                    <th>Quantité</th>
                    <th>Sous-total</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="ligne" items="${panier.lignes}">
                    <tr>
                        <td><strong>${ligne.produit.libelle}</strong></td>
                        <td><fmt:formatNumber value="${ligne.prixUnitaire}" type="currency" currencyCode="MAD"/></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/panier?action=update" method="post" class="update-form">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <input type="hidden" name="id" value="${ligne.produit.id}">
                                <input type="number" name="q" value="${ligne.quantite}" min="1" max="${ligne.produit.stock}" class="quantity-input">
                                <button type="submit" class="btn btn-small">Mettre à jour</button>
                            </form>
                        </td>
                        <td><strong><fmt:formatNumber value="${ligne.sousTotal}" type="currency" currencyCode="MAD"/></strong></td>
                        <td>
                            <form action="${pageContext.request.contextPath}/panier?action=remove" method="post" class="remove-form">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <input type="hidden" name="id" value="${ligne.produit.id}">
                                <button type="submit" class="btn btn-danger btn-small">Retirer</button>
                            </form>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        
        <div class="cart-summary">
            <div class="summary-row">
                <span class="detail-label" style="margin: 0;">Nombre d'articles</span>
                <span class="detail-value" style="font-size: 1rem;">${panier.lignes.size()}</span>
            </div>
            <div class="summary-row">
                <span class="detail-label" style="margin: 0;">Total à payer</span>
                <span style="background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%); -webkit-background-clip: text; -webkit-text-fill-color: transparent; font-weight: 700;">
                    <fmt:formatNumber value="${panier.total}" type="currency" currencyCode="MAD"/>
                </span>
            </div>
        </div>
        
        <div class="cart-actions-container">
            <form action="${pageContext.request.contextPath}/panier?action=clear" method="post">
                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                <button type="submit" class="btn btn-secondary" onclick="return confirm('Voulez-vous vraiment vider votre panier ?')">Vider le panier</button>
            </form>
            <div class="action-buttons">
                <a href="${pageContext.request.contextPath}/produits?action=list" class="btn btn-secondary">Continuer mes achats</a>
                <form action="${pageContext.request.contextPath}/panier?action=checkout" method="post">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <button type="submit" class="btn btn-large">Valider la commande</button>
                </form>
            </div>
        </div>
    </c:if>
</div>

</main>
<footer class="footer">
    <div class="container">
        <p>&copy; 2025 E-Shop. Tous droits réservés.</p>
    </div>
</footer>
</body>
</html>
