<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<c:set var="pageTitle" value="Mes Produits"/>
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

.form-grid-2col {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 1.5rem;
}

.form-group-full {
    grid-column: 1 / -1;
}

.product-form-actions {
    display: flex;
    gap: 1rem;
    margin-top: 2rem;
}

.status-badge {
    display: inline-flex;
    align-items: center;
    padding: 0.375rem 0.875rem;
    border-radius: var(--radius-md);
    font-size: 0.875rem;
    font-weight: 600;
    border: 1px solid;
}

.status-badge.active {
    background: rgba(16, 185, 129, 0.15);
    color: #6ee7b7;
    border-color: rgba(16, 185, 129, 0.3);
}

.status-badge.inactive {
    background: rgba(239, 68, 68, 0.15);
    color: #fca5a5;
    border-color: rgba(239, 68, 68, 0.3);
}

.stock-indicator {
    font-weight: 600;
}

.stock-indicator.high {
    color: #6ee7b7;
}

.stock-indicator.medium {
    color: #fcd34d;
}

.stock-indicator.low {
    color: #fca5a5;
}

.checkbox-group {
    display: flex;
    align-items: center;
    gap: 0.75rem;
    padding: 1rem;
    background: rgba(99, 102, 241, 0.05);
    border-radius: var(--radius-md);
    border-left: 4px solid var(--primary-color);
    cursor: pointer;
    transition: all 0.3s ease;
}

.checkbox-group:hover {
    background: rgba(99, 102, 241, 0.1);
}

.checkbox-group input[type="checkbox"] {
    width: 1.25rem;
    height: 1.25rem;
    cursor: pointer;
}

.table-actions {
    display: flex;
    gap: 0.5rem;
}

@media (max-width: 768px) {
    .form-grid-2col {
        grid-template-columns: 1fr;
    }
}
</style>

<div class="container">
    <div class="page-header">
        <div>
            <h1>Mes Produits</h1>
            <p style="color: var(--text-muted); margin-top: 0.5rem;">Gérez votre catalogue de produits</p>
        </div>
    </div>

    <div class="admin-section">
        <h2 id="formTitle">${produit != null ? 'Modifier le Produit' : 'Ajouter un Nouveau Produit'}</h2>
        <form action="${pageContext.request.contextPath}/seller/produits" method="post" class="admin-form" id="produitForm">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            <input type="hidden" name="action" value="${produit != null ? 'update' : 'create'}" id="formAction">
            <input type="hidden" name="id" value="${produit != null ? produit.id : ''}" id="produitId">

            <div class="form-grid-2col">
                <div class="form-group form-group-full">
                    <label for="libelle">Libellé du produit</label>
                    <input type="text" id="libelle" name="libelle" value="${produit != null ? produit.libelle : ''}" required class="form-input" placeholder="Ex: Laptop Dell XPS 15">
                </div>

                <div class="form-group form-group-full">
                    <label for="description">Description</label>
                    <textarea id="description" name="description" rows="4" class="form-input" placeholder="Description détaillée du produit...">${produit != null ? produit.description : ''}</textarea>
                </div>

                <div class="form-group">
                    <label for="prix">Prix (MAD)</label>
                    <input type="number" id="prix" name="prix" value="${produit != null ? produit.prix : ''}" step="0.01" min="0" required class="form-input" placeholder="0.00">
                </div>

                <div class="form-group">
                    <label for="stock">Stock disponible</label>
                    <input type="number" id="stock" name="stock" value="${produit != null ? produit.stock : ''}" min="0" required class="form-input" placeholder="0">
                </div>

                <div class="form-group form-group-full">
                    <label class="checkbox-group">
                        <input type="checkbox" name="actif" id="actif" ${produit == null || produit.actif ? 'checked' : ''}>
                        <span style="font-weight: 600;">Produit actif et visible dans le catalogue</span>
                    </label>
                </div>
            </div>

            <div class="product-form-actions">
                <button type="submit" class="btn btn-large" id="submitBtn">${produit != null ? 'Enregistrer les modifications' : 'Créer le produit'}</button>
                <c:if test="${produit != null}">
                    <a href="${pageContext.request.contextPath}/seller/produits" class="btn btn-secondary btn-large">Annuler</a>
                </c:if>
            </div>
        </form>
    </div>

    <div class="admin-section">
        <h2>Liste de Mes Produits</h2>

        <c:choose>
            <c:when test="${not empty produits}">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Libellé</th>
                            <th>Prix</th>
                            <th>Stock</th>
                            <th>Statut</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${produits}">
                            <tr>
                                <td><strong>#${p.id}</strong></td>
                                <td>${p.libelle}</td>
                                <td><strong><fmt:formatNumber value="${p.prix}" type="currency" currencyCode="MAD"/></strong></td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.stock > 10}">
                                            <span class="stock-indicator high">${p.stock} unités</span>
                                        </c:when>
                                        <c:when test="${p.stock > 0}">
                                            <span class="stock-indicator medium">${p.stock} unités</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="stock-indicator low">Rupture</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <c:choose>
                                        <c:when test="${p.actif}">
                                            <span class="status-badge active">Actif</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="status-badge inactive">Inactif</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <div class="table-actions">
                                        <a href="${pageContext.request.contextPath}/seller/produits?action=edit&id=${p.id}#produitForm" class="btn btn-secondary btn-small">Modifier</a>
                                        <form action="${pageContext.request.contextPath}/seller/produits" method="post" style="display: inline;" onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer ce produit ?');">
                                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${p.id}">
                                            <button type="submit" class="btn btn-danger btn-small">Supprimer</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:when>
            <c:otherwise>
                <div class="no-results">
                    <p>Vous n'avez pas encore ajouté de produits.</p>
                    <p style="color: var(--text-muted); margin-top: 0.5rem;">Commencez par créer votre premier produit ci-dessus.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
</div>

</main>
<footer class="footer">
    <div class="container">
        <p>&copy; 2025 E-Shop. Tous droits réservés.</p>
    </div>
</footer>

<script>
    <c:if test="${not empty produit}">
        window.addEventListener('load', function() {
            const form = document.getElementById('produitForm');
            if (form) {
                form.scrollIntoView({ behavior: 'smooth', block: 'start' });
                document.getElementById('libelle').focus();
            }
        });
    </c:if>
</script>
</body>
</html>
