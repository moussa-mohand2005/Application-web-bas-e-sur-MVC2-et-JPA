<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<c:set var="pageTitle" value="Connexion"/>
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
    background: linear-gradient(135deg, var(--primary-color) 0%, var(--secondary-color) 100%);
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
    max-width: 500px;
    margin: 0 auto;
    background: var(--card-background);
    padding: 3rem;
    border-radius: var(--radius-xl);
    box-shadow: var(--shadow-xl);
    border: 1px solid var(--border-color);
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
</style>

<div class="container">
    <div class="page-header">
        <div class="auth-icon">
            <svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                <path d="M12 11c2.21 0 4-1.79 4-4s-1.79-4-4-4-4 1.79-4 4 1.79 4 4 4zm0 2c-4.42 0-8 1.79-8 4v2h16v-2c0-2.21-3.58-4-8-4z"/>
            </svg>
        </div>
        <div>
            <h1>Connexion</h1>
            <p style="color: var(--text-muted); margin-top: 0.5rem;">Connectez-vous à votre compte</p>
        </div>
    </div>
    
    <div class="auth-card">
        <c:if test="${not empty error}">
            <div class="alert alert-error">${error}</div>
        </c:if>
        
        <form action="${pageContext.request.contextPath}/auth?action=login" method="post" class="auth-form">
            <input type="hidden" name="csrfToken" value="${sessionScope.csrfToken}">
            <c:if test="${not empty param.redirect}">
                <input type="hidden" name="redirect" value="${param.redirect}">
            </c:if>
            
            <div class="form-group">
                <label for="email">Adresse email</label>
                <input type="email" id="email" name="email" value="${email}" required class="form-input" placeholder="votreemail@exemple.com" autocomplete="email">
            </div>
            
            <div class="form-group">
                <label for="password">Mot de passe</label>
                <input type="password" id="password" name="password" required class="form-input" placeholder="Entrez votre mot de passe" autocomplete="current-password">
            </div>
            
            <button type="submit" class="btn btn-large btn-block" style="margin-top: 1.5rem;">Se connecter</button>
        </form>
        
        <div class="auth-divider">
            <span>Nouveau sur E-Shop ?</span>
        </div>
        
        <p class="auth-link">
            <a href="${pageContext.request.contextPath}/auth?action=register" class="btn btn-secondary btn-block">Créer un compte</a>
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
