package net.moussa.jpa.web;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import net.moussa.jpa.entities.Internaute;
import net.moussa.jpa.service.AuthService;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/auth")
public class AuthServlet extends HttpServlet {
    
    @Inject
    private AuthService authService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("login".equals(action)) {
            req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, resp);
        } else if ("register".equals(action)) {
            req.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("login".equals(action)) {
            handleLogin(req, resp);
        } else if ("register".equals(action)) {
            handleRegister(req, resp);
        } else if ("logout".equals(action)) {
            handleLogout(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        
        if (email == null || email.trim().isEmpty() || password == null || password.isEmpty()) {
            req.setAttribute("error", "Email et mot de passe requis");
            req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, resp);
            return;
        }
        
        Optional<Internaute> internauteOpt = authService.authenticate(email.trim(), password);
        
        if (internauteOpt.isPresent()) {
            Internaute internaute = internauteOpt.get();
            HttpSession session = req.getSession();
            session.setAttribute("userId", internaute.getId());
            session.setAttribute("userName", internaute.getNom());
            session.setAttribute("userEmail", internaute.getEmail());
            session.setAttribute("role", internaute.getRole().name());
            
            String redirect = req.getParameter("redirect");
            if (redirect != null && !redirect.isEmpty()) {
                resp.sendRedirect(req.getContextPath() + redirect);
            } else {
                resp.sendRedirect(req.getContextPath() + "/produits?action=list");
            }
        } else {
            req.setAttribute("error", "Email ou mot de passe incorrect");
            req.setAttribute("email", email);
            req.getRequestDispatcher("/WEB-INF/jsp/login.jsp").forward(req, resp);
        }
    }

    private void handleRegister(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String nom = req.getParameter("nom");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String confirmPassword = req.getParameter("confirmPassword");
        String adresse = req.getParameter("adresse");
        String telephone = req.getParameter("telephone");
        
        if (nom == null || nom.trim().isEmpty() || 
            email == null || email.trim().isEmpty() || 
            password == null || password.isEmpty()) {
            req.setAttribute("error", "Nom, email et mot de passe sont requis");
            req.setAttribute("nom", nom);
            req.setAttribute("email", email);
            req.setAttribute("adresse", adresse);
            req.setAttribute("telephone", telephone);
            req.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(req, resp);
            return;
        }
        
        if (!password.equals(confirmPassword)) {
            req.setAttribute("error", "Les mots de passe ne correspondent pas");
            req.setAttribute("nom", nom);
            req.setAttribute("email", email);
            req.setAttribute("adresse", adresse);
            req.setAttribute("telephone", telephone);
            req.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(req, resp);
            return;
        }
        
        try {
            Internaute internaute = authService.register(
                nom.trim(), 
                email.trim(), 
                password, 
                adresse != null ? adresse.trim() : "", 
                telephone != null ? telephone.trim() : ""
            );
            
            HttpSession session = req.getSession();
            session.setAttribute("userId", internaute.getId());
            session.setAttribute("userName", internaute.getNom());
            session.setAttribute("userEmail", internaute.getEmail());
            session.setAttribute("role", internaute.getRole().name());
            
            resp.sendRedirect(req.getContextPath() + "/produits?action=list");
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            req.setAttribute("nom", nom);
            req.setAttribute("email", email);
            req.setAttribute("adresse", adresse);
            req.setAttribute("telephone", telephone);
            req.getRequestDispatcher("/WEB-INF/jsp/register.jsp").forward(req, resp);
        }
    }

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/produits?action=list");
    }
}

