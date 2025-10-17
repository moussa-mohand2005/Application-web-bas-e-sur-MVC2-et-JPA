<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Inscription"/>
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

.auth-icon {
    width: 80px;
    height: 80px;
    margin: 0 auto 1.5rem;
    background: linear-gradient(135deg, var(--secondary-color) 0%, var(--primary-color) 100%);
    border-radius: 50%;
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: var(--shadow-glow);
}

.auth-icon svg {
    width: 40px;
    height: 40px;
    stroke: white;
}

.auth-card {
    max-width: 600px;
    margin: 0 auto;
    background: var(--card-background);
    padding: 3rem;
    border-radius: var(--radius-xl);
    box-shadow: var(--shadow-xl);
    border: 1px solid var(--border-color);
}

.form-grid {
    display: grid;
    grid-template-columns: repeat(2, 1fr);
    gap: 1.5rem;
}

.form-group-full {
    grid-column: 1 / -1;
}

.auth-divider {
    margin: 2rem 0;
    text-align: center;
    position: relative;
}

.auth-divider::before {
    content: '';
    position: absolute;
    top: 50%;
    left: 0;
    right: 0;
    height: 1px;
    background: var(--border-color);
}

.auth-divider span {
    background: var(--card-background);
    padding: 0 1rem;
    position: relative;
    color: var(--text-muted);
    font-size: 0.875rem;
    text-transform: uppercase;
    letter-spacing: 0.05em;
}

@media (max-width: 640px) {
    .form-grid {
        grid-template-columns: 1fr;
    }
}
</style>

<div class="container">
    <div class="page-header">
        <div class="auth-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M16 21v-2a4 4 0 00-4-4H5a4 4 0 00-4 4v2M12 11a4 4 0 100-8 4 4 0 000 8zM20 8v6M23 11h-6"/>
            </svg>
        </div>
        <div>
            <h1>Inscription</h1>
            <p style="color: var(--text-muted); margin-top: 0.5rem;">Créez votre compte gratuitement</p>
        </div>
    </div>
    
    <div class="auth-card">
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/auth?action=register" method="post" class="auth-form">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            
            <div class="form-grid">
                <div class="form-group form-group-full">
                    <label for="nom">Nom complet</label>
                    <input type="text" id="nom" name="nom" value="${nom}" required class="form-input" placeholder="Jean Dupont">
                </div>
                
                <div class="form-group form-group-full">
                    <label for="email">Adresse email</label>
                    <input type="email" id="email" name="email" value="${email}" required class="form-input" placeholder="votreemail@exemple.com">
                </div>
                
                <div class="form-group">
                    <label for="password">Mot de passe</label>
                    <input type="password" id="password" name="password" required minlength="6" class="form-input" placeholder="Min. 6 caractères">
                </div>
                
                <div class="form-group">
                    <label for="confirmPassword">Confirmer le mot de passe</label>
                    <input type="password" id="confirmPassword" name="confirmPassword" required minlength="6" class="form-input" placeholder="Confirmez">
                </div>
                
                <div class="form-group">
                    <label for="telephone">Téléphone</label>
                    <input type="tel" id="telephone" name="telephone" value="${telephone}" class="form-input" placeholder="+212 6XX-XXXXXX">
                </div>
                
                <div class="form-group">
                    <label for="adresse">Adresse</label>
                    <input type="text" id="adresse" name="adresse" value="${adresse}" class="form-input" placeholder="Ville, Pays">
                </div>
            </div>
            
            <button type="submit" class="btn btn-large btn-block" style="margin-top: 1.5rem;">Créer mon compte</button>
        </form>
        
        <div class="auth-divider">
            <span>Vous avez déjà un compte ?</span>
        </div>
        
        <p class="auth-link">
            <a href="${pageContext.request.contextPath}/auth?action=login" class="btn btn-secondary btn-block">Se connecter</a>
        </p>
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
