<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Gestion des Utilisateurs"/>
<%@ include file="layout.jspf" %>

<style>
.admin-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 2.5rem;
    padding-bottom: 1.5rem;
    border-bottom: 2px solid var(--border-color);
}

.admin-header h1 {
    margin: 0;
}

.stats-grid {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
    gap: 1.5rem;
    margin-bottom: 2rem;
}

.stat-card {
    background: linear-gradient(135deg, rgba(99, 102, 241, 0.1) 0%, rgba(236, 72, 153, 0.1) 100%);
    padding: 1.5rem;
    border-radius: var(--radius-lg);
    border: 1px solid var(--border-light);
}

.stat-label {
    font-size: 0.875rem;
    color: var(--text-muted);
    margin-bottom: 0.5rem;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

.stat-value {
    font-size: 2rem;
    font-weight: 700;
    color: var(--text-primary);
}

.role-badge {
    display: inline-flex;
    align-items: center;
    padding: 0.375rem 0.875rem;
    border-radius: var(--radius-md);
    font-size: 0.875rem;
    font-weight: 600;
    border: 1px solid;
}

.role-badge.admin {
    background: rgba(239, 68, 68, 0.15);
    color: #fca5a5;
    border-color: rgba(239, 68, 68, 0.3);
}

.role-badge.seller {
    background: rgba(236, 72, 153, 0.15);
    color: #f9a8d4;
    border-color: rgba(236, 72, 153, 0.3);
}

.role-badge.buyer {
    background: rgba(99, 102, 241, 0.15);
    color: #a5b4fc;
    border-color: rgba(99, 102, 241, 0.3);
}

.user-details-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 2rem;
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

.table-actions {
    display: flex;
    gap: 0.5rem;
}

@media (max-width: 768px) {
    .user-details-grid {
        grid-template-columns: 1fr;
    }
}
</style>

<div class="container">
    <div class="admin-header">
        <div>
            <h1>Gestion des Utilisateurs</h1>
            <p style="color: var(--text-muted); margin-top: 0.5rem;">Gérez les utilisateurs et leurs rôles</p>
        </div>
    </div>
    
    <div class="admin-section">
        <h2>Liste des Utilisateurs</h2>
        
        <c:choose>
            <c:when test="${not empty users}">
                <table class="admin-table">
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Nom</th>
                            <th>Email</th>
                            <th>Téléphone</th>
                            <th>Adresse</th>
                            <th>Rôle Actuel</th>
                            <th>Changer le Rôle</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td><strong>#${u.id}</strong></td>
                                <td>${u.nom}</td>
                                <td style="color: var(--text-muted);">${u.email}</td>
                                <td>${not empty u.telephone ? u.telephone : '—'}</td>
                                <td>${not empty u.adresse ? u.adresse : '—'}</td>
                                <td>
                                    <c:choose>
                                        <c:when test="${u.role == 'ADMIN'}">
                                            <span class="role-badge admin">Administrateur</span>
                                        </c:when>
                                        <c:when test="${u.role == 'VENDEUR'}">
                                            <span class="role-badge seller">Vendeur</span>
                                        </c:when>
                                        <c:otherwise>
                                            <span class="role-badge buyer">Acheteur</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                                <td>
                                    <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display: inline;" onchange="this.submit()">
                                        <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                        <input type="hidden" name="action" value="changeRole">
                                        <input type="hidden" name="id" value="${u.id}">
                                        <select name="role" class="form-input" style="width: auto; display: inline-block; padding: 0.5rem;">
                                            <c:forEach var="r" items="${roles}">
                                                <option value="${r}" ${r == u.role ? 'selected' : ''}>
                                                    <c:choose>
                                                        <c:when test="${r == 'ADMIN'}">Administrateur</c:when>
                                                        <c:when test="${r == 'VENDEUR'}">Vendeur</c:when>
                                                        <c:otherwise>Acheteur</c:otherwise>
                                                    </c:choose>
                                                </option>
                                            </c:forEach>
                                        </select>
                                    </form>
                                </td>
                                <td>
                                    <div class="table-actions">
                                        <a href="${pageContext.request.contextPath}/admin/users?action=details&id=${u.id}#userDetails" class="btn btn-secondary btn-small">Détails</a>
                                        <form action="${pageContext.request.contextPath}/admin/users" method="post" style="display: inline;" onsubmit="return confirm('Êtes-vous sûr de vouloir supprimer cet utilisateur ?');">
                                            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="id" value="${u.id}">
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
                    <p>Aucun utilisateur trouvé.</p>
                </div>
            </c:otherwise>
        </c:choose>
    </div>
    
    <c:if test="${not empty selectedUser}">
        <div class="admin-section" id="userDetails">
            <h2>Détails de l'Utilisateur</h2>
            <div class="user-details-grid">
                <div class="detail-item">
                    <div class="detail-label">Identifiant</div>
                    <div class="detail-value">#${selectedUser.id}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Nom complet</div>
                    <div class="detail-value">${selectedUser.nom}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Adresse email</div>
                    <div class="detail-value">${selectedUser.email}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Téléphone</div>
                    <div class="detail-value">${not empty selectedUser.telephone ? selectedUser.telephone : 'Non renseigné'}</div>
                </div>
                <div class="detail-item" style="grid-column: 1 / -1;">
                    <div class="detail-label">Adresse complète</div>
                    <div class="detail-value">${not empty selectedUser.adresse ? selectedUser.adresse : 'Non renseignée'}</div>
                </div>
                <div class="detail-item">
                    <div class="detail-label">Rôle</div>
                    <div class="detail-value">
                        <c:choose>
                            <c:when test="${selectedUser.role == 'ADMIN'}">
                                <span class="role-badge admin">Administrateur</span>
                            </c:when>
                            <c:when test="${selectedUser.role == 'VENDEUR'}">
                                <span class="role-badge seller">Vendeur</span>
                            </c:when>
                            <c:otherwise>
                                <span class="role-badge buyer">Acheteur</span>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </div>
            </div>
            <div style="margin-top: 2rem;">
                <a href="${pageContext.request.contextPath}/admin/users" class="btn">Retour à la liste</a>
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

<c:if test="${not empty selectedUser}">
<script>
    window.addEventListener('load', function() {
        const details = document.getElementById('userDetails');
        if (details) {
            details.scrollIntoView({ behavior: 'smooth', block: 'start' });
        }
    });
</script>
</c:if>
</body>
</html>
