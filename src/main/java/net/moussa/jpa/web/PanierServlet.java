package net.moussa.jpa.web;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import net.moussa.jpa.entities.Internaute;
import net.moussa.jpa.entities.Panier;
import net.moussa.jpa.service.AuthService;
import net.moussa.jpa.service.PanierService;
import java.io.IOException;
import java.util.Optional;

@WebServlet("/panier")
public class PanierServlet extends HttpServlet {
    
    @Inject
    private PanierService panierService;
    
    @Inject
    private AuthService authService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if (action == null || "view".equals(action)) {
            handleView(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/panier?action=view");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("add".equals(action)) {
            handleAdd(req, resp);
        } else if ("update".equals(action)) {
            handleUpdate(req, resp);
        } else if ("remove".equals(action)) {
            handleRemove(req, resp);
        } else if ("clear".equals(action)) {
            handleClear(req, resp);
        } else if ("checkout".equals(action)) {
            handleCheckout(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/panier?action=view");
        }
    }

    private void handleView(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Internaute internaute = getCurrentUser(req);
        if (internaute == null) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login&redirect=/panier");
            return;
        }
        
        Panier panier = panierService.getOrCreatePanierActif(internaute);
        req.setAttribute("panier", panier);
        req.getRequestDispatcher("/WEB-INF/jsp/panier.jsp").forward(req, resp);
    }

    private void handleAdd(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Internaute internaute = getCurrentUser(req);
        if (internaute == null) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }
        
        String idParam = req.getParameter("id");
        String qteParam = req.getParameter("q");
        
        try {
            Long produitId = Long.parseLong(idParam);
            int quantite = qteParam != null ? Integer.parseInt(qteParam) : 1;
            
            if (quantite <= 0) {
                quantite = 1;
            }
            
            panierService.add(internaute, produitId, quantite);
            resp.sendRedirect(req.getContextPath() + "/panier?action=view");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/produits?action=list");
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            handleView(req, resp);
        }
    }

    private void handleUpdate(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Internaute internaute = getCurrentUser(req);
        if (internaute == null) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }
        
        String idParam = req.getParameter("id");
        String qteParam = req.getParameter("q");
        
        try {
            Long produitId = Long.parseLong(idParam);
            int quantite = Integer.parseInt(qteParam);
            
            panierService.updateQuantite(internaute, produitId, quantite);
            resp.sendRedirect(req.getContextPath() + "/panier?action=view");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/panier?action=view");
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            handleView(req, resp);
        }
    }

    private void handleRemove(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Internaute internaute = getCurrentUser(req);
        if (internaute == null) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }
        
        String idParam = req.getParameter("id");
        
        try {
            Long produitId = Long.parseLong(idParam);
            panierService.remove(internaute, produitId);
            resp.sendRedirect(req.getContextPath() + "/panier?action=view");
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/panier?action=view");
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            handleView(req, resp);
        }
    }

    private void handleClear(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Internaute internaute = getCurrentUser(req);
        if (internaute == null) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }
        
        panierService.clear(internaute);
        resp.sendRedirect(req.getContextPath() + "/panier?action=view");
    }

    private void handleCheckout(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        Internaute internaute = getCurrentUser(req);
        if (internaute == null) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }
        
        try {
            panierService.checkout(internaute);
            req.setAttribute("success", "Commande validée avec succès");
            req.getRequestDispatcher("/WEB-INF/jsp/checkout.jsp").forward(req, resp);
        } catch (IllegalArgumentException e) {
            req.setAttribute("error", e.getMessage());
            handleView(req, resp);
        }
    }

    private Internaute getCurrentUser(HttpServletRequest req) {
        HttpSession session = req.getSession(false);
        if (session == null) {
            return null;
        }
        
        Long userId = (Long) session.getAttribute("userId");
        if (userId == null) {
            return null;
        }
        
        Optional<Internaute> internauteOpt = authService.findById(userId);
        return internauteOpt.orElse(null);
    }
}

