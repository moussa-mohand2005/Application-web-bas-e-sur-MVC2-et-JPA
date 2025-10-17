<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Produits"/>
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

.search-section {
    background: var(--card-background);
    padding: 2rem;
    border-radius: var(--radius-xl);
    margin-bottom: 2.5rem;
    box-shadow: var(--shadow-lg);
    border: 1px solid var(--border-color);
}

.search-section form {
    display: flex;
    gap: 1rem;
    max-width: 800px;
    margin: 0 auto;
}

.stock-badge {
    display: inline-flex;
    align-items: center;
    padding: 0.375rem 0.875rem;
    border-radius: var(--radius-md);
    font-size: 0.875rem;
    font-weight: 600;
    border: 1px solid;
}

.stock-badge.in-stock {
    background: rgba(16, 185, 129, 0.15);
    color: #6ee7b7;
    border-color: rgba(16, 185, 129, 0.3);
}

.stock-badge.low-stock {
    background: rgba(245, 158, 11, 0.15);
    color: #fcd34d;
    border-color: rgba(245, 158, 11, 0.3);
}

.stock-badge.out-of-stock {
    background: rgba(239, 68, 68, 0.15);
    color: #fca5a5;
    border-color: rgba(239, 68, 68, 0.3);
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
</style>

<div class="container">
    <div class="page-header">
        <div>
            <h1>Catalogue des Produits</h1>
            <p style="color: var(--text-muted); margin-top: 0.5rem;">Découvrez notre sélection exclusive</p>
        </div>
    </div>
    
    <div class="search-section">
        <form action="${pageContext.request.contextPath}/produits" method="get">
            <input type="hidden" name="action" value="search">
            <input type="text" name="q" placeholder="Rechercher un produit..." value="${searchQuery}" class="search-input">
            <button type="submit" class="btn btn-large">Rechercher</button>
        </form>
    </div>
    
    <c:if test="${not empty searchQuery}">
        <p class="search-info">Résultats de recherche pour : <strong>"${searchQuery}"</strong></p>
    </c:if>
    
    <c:if test="${empty produits}">
        <div class="empty-state">
            <h3>Aucun produit trouvé</h3>
            <p style="color: var(--text-muted);">Essayez une autre recherche ou parcourez notre catalogue</p>
        </div>
    </c:if>
    
    <div class="product-grid">
        <c:forEach var="produit" items="${produits}">
            <div class="product-card">
                <div class="product-image">
                    <div class="image-placeholder">
                        <svg width="80" height="80" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="1.5">
                            <path d="M20 7L12 3L4 7M20 7L12 11M20 7V17L12 21M12 11L4 7M12 11V21M4 7V17L12 21"/>
                        </svg>
                    </div>
                </div>
                <div class="product-info">
                    <h3 class="product-title">${produit.libelle}</h3>
                    <p class="product-price"><fmt:formatNumber value="${produit.prix}" type="currency" currencyCode="MAD"/></p>
                    <p class="product-stock">
                        <c:choose>
                            <c:when test="${produit.stock > 10}">
                                <span class="stock-badge in-stock">En stock (${produit.stock})</span>
                            </c:when>
                            <c:when test="${produit.stock > 0}">
                                <span class="stock-badge low-stock">Stock limité (${produit.stock})</span>
                            </c:when>
                            <c:otherwise>
                                <span class="stock-badge out-of-stock">Rupture de stock</span>
                            </c:otherwise>
                        </c:choose>
                    </p>
                    <div class="product-actions">
                        <a href="${pageContext.request.contextPath}/produits?action=details&id=${produit.id}" class="btn btn-secondary">Voir détails</a>
                        <c:if test="${produit.stock > 0}">
                            <form action="${pageContext.request.contextPath}/panier?action=add" method="post" class="add-to-cart-form">
                                <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                <input type="hidden" name="id" value="${produit.id}">
                                <input type="number" name="q" value="1" min="1" max="${produit.stock}" class="quantity-input">
                                <button type="submit" class="btn">Ajouter</button>
                            </form>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
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
