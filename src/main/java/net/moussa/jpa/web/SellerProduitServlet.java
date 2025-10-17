package net.moussa.jpa.web;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import net.moussa.jpa.entities.Internaute;
import net.moussa.jpa.entities.Produit;
import net.moussa.jpa.service.AuthService;
import net.moussa.jpa.service.ProduitService;
import java.io.IOException;
import java.math.BigDecimal;

@WebServlet("/seller/produits")
public class SellerProduitServlet extends HttpServlet {

    @Inject
    private ProduitService produitService;

    @Inject
    private AuthService authService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        Long userId = session != null ? (Long) session.getAttribute("userId") : null;
        Internaute vendeur = userId != null ? authService.findById(userId).orElse(null) : null;
        if (vendeur == null) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }
        
        String action = req.getParameter("action");
        if ("edit".equals(action)) {
            String idParam = req.getParameter("id");
            if (idParam != null) {
                Long id = Long.parseLong(idParam);
                produitService.findById(id).ifPresent(prod -> {
                    if (prod.getVendeur() != null && prod.getVendeur().getId().equals(vendeur.getId())) {
                        req.setAttribute("produit", prod);
                    }
                });
            }
        }
        
        req.setAttribute("produits", produitService.findByVendeur(vendeur.getId()));
        req.getRequestDispatcher("/WEB-INF/jsp/seller-produits.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        HttpSession session = req.getSession(false);
        Long userId = session != null ? (Long) session.getAttribute("userId") : null;
        Internaute vendeur = userId != null ? authService.findById(userId).orElse(null) : null;
        if (vendeur == null) {
            resp.sendRedirect(req.getContextPath() + "/auth?action=login");
            return;
        }
        if ("create".equals(action)) {
            Produit p = new Produit();
            p.setLibelle(req.getParameter("libelle"));
            p.setDescription(req.getParameter("description"));
            p.setPrix(new BigDecimal(req.getParameter("prix")));
            p.setStock(Integer.parseInt(req.getParameter("stock")));
            p.setActif("on".equals(req.getParameter("actif")));
            produitService.createForVendeur(vendeur, p);
        } else if ("update".equals(action)) {
            Long id = Long.parseLong(req.getParameter("id"));
            produitService.findById(id).ifPresent(prod -> {
                if (prod.getVendeur() != null && prod.getVendeur().getId().equals(vendeur.getId())) {
                    prod.setLibelle(req.getParameter("libelle"));
                    prod.setDescription(req.getParameter("description"));
                    prod.setPrix(new BigDecimal(req.getParameter("prix")));
                    prod.setStock(Integer.parseInt(req.getParameter("stock")));
                    prod.setActif("on".equals(req.getParameter("actif")));
                    produitService.update(prod);
                }
            });
        } else if ("delete".equals(action)) {
            Long id = Long.parseLong(req.getParameter("id"));
            produitService.findById(id).ifPresent(prod -> {
                if (prod.getVendeur() != null && prod.getVendeur().getId().equals(vendeur.getId())) {
                    produitService.delete(id);
                }
            });
        }
        resp.sendRedirect(req.getContextPath() + "/seller/produits");
    }
}
