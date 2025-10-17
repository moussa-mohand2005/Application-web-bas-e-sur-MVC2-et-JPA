<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="${produit.libelle}"/>
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

.breadcrumb {
    display: flex;
    gap: 0.5rem;
    font-size: 0.875rem;
    color: var(--text-muted);
    margin-bottom: 2rem;
}

.breadcrumb a {
    color: var(--primary-light);
    text-decoration: none;
}

.breadcrumb a:hover {
    text-decoration: underline;
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

.availability-badge {
    display: inline-flex;
    align-items: center;
    padding: 0.375rem 0.875rem;
    border-radius: var(--radius-md);
    font-size: 0.875rem;
    font-weight: 600;
    border: 1px solid;
}

.availability-badge.available {
    background: rgba(16, 185, 129, 0.15);
    color: #6ee7b7;
    border-color: rgba(16, 185, 129, 0.3);
}

.availability-badge.limited {
    background: rgba(245, 158, 11, 0.15);
    color: #fcd34d;
    border-color: rgba(245, 158, 11, 0.3);
}

.availability-badge.unavailable {
    background: rgba(239, 68, 68, 0.15);
    color: #fca5a5;
    border-color: rgba(239, 68, 68, 0.3);
}
</style>

<div class="container">
    <nav class="breadcrumb">
        <a href="${pageContext.request.contextPath}/produits?action=list">Produits</a>
        <span>/</span>
        <span>${produit.libelle}</span>
    </nav>
    
    <div class="product-details">
        <div class="product-image-large">
            <div class="image-placeholder-large">
                <svg width="160" height="160" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1">
                    <path d="M20 7L12 3L4 7M20 7L12 11M20 7V17L12 21M12 11L4 7M12 11V21M4 7V17L12 21"/>
                </svg>
            </div>
        </div>
        <div class="product-info-large">
            <h1>${produit.libelle}</h1>
            <p class="price-large"><fmt:formatNumber value="${produit.prix}" type="currency" currencyCode="MAD"/></p>
            
            <div style="margin: 2rem 0;">
                <div class="detail-item">
                    <div class="detail-label">Disponibilité</div>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${produit.stock > 10}">
                                <span class="availability-badge available">En stock (${produit.stock} unités)</span>
                            </c:when>
                            <c:when test="${produit.stock > 0}">
                                <span class="availability-badge limited">Stock limité (${produit.stock} unités)</span>
                            </c:when>
                            <c:otherwise>
                                <span class="availability-badge unavailable">Rupture de stock</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            
            <div class="description">
                <h3>Description du produit</h3>
                <div class="detail-item" style="margin-top: 1rem;">
                    <p>${produit.description != null ? produit.description : 'Aucune description disponible pour ce produit.'}</p>
                </div>
            </div>
            
            <c:if test="${produit.stock > 0}">
                <form action="${pageContext.request.contextPath}/panier?action=add" method="post" class="add-form">
                    <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                    <input type="hidden" name="id" value="${produit.id}">
                    <div class="form-group">
                        <label for="quantity">Quantité</label>
                        <div style="display: flex; align-items: center; gap: 1rem;">
                            <input type="number" id="quantity" name="q" value="1" min="1" max="${produit.stock}" class="quantity-input-large">
                            <span class="detail-label" style="margin: 0;">/ ${produit.stock} disponibles</span>
                        </div>
                    </div>
                    <button type="submit" class="btn btn-large">Ajouter au panier</button>
                </form>
            </c:if>
            
            <c:if test="${produit.stock <= 0}">
                <div class="out-of-stock">Ce produit n'est actuellement pas disponible</div>
            </c:if>
            
            <div class="back-link">
                <a href="${pageContext.request.contextPath}/produits?action=list" class="btn btn-secondary">Retour aux produits</a>
            </div>
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
