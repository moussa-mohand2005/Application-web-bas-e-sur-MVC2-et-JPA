package net.moussa.jpa.web;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import net.moussa.jpa.entities.Produit;
import net.moussa.jpa.service.ProduitService;
import java.io.IOException;
import java.util.List;
import java.util.Optional;

@WebServlet("/produits")
public class ProduitServlet extends HttpServlet {
    
    @Inject
    private ProduitService produitService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if (action == null || "list".equals(action)) {
            handleList(req, resp);
        } else if ("details".equals(action)) {
            handleDetails(req, resp);
        } else if ("search".equals(action)) {
            handleSearch(req, resp);
        } else {
            resp.sendRedirect(req.getContextPath() + "/produits?action=list");
        }
    }

    private void handleList(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        List<Produit> produits = produitService.findAll();
        req.setAttribute("produits", produits);
        req.getRequestDispatcher("/WEB-INF/jsp/produits.jsp").forward(req, resp);
    }

    private void handleDetails(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String idParam = req.getParameter("id");
        
        if (idParam == null) {
            resp.sendRedirect(req.getContextPath() + "/produits?action=list");
            return;
        }
        
        try {
            Long id = Long.parseLong(idParam);
            Optional<Produit> produitOpt = produitService.findById(id);
            
            if (produitOpt.isPresent()) {
                req.setAttribute("produit", produitOpt.get());
                req.getRequestDispatcher("/WEB-INF/jsp/produit-details.jsp").forward(req, resp);
            } else {
                resp.sendRedirect(req.getContextPath() + "/produits?action=list");
            }
        } catch (NumberFormatException e) {
            resp.sendRedirect(req.getContextPath() + "/produits?action=list");
        }
    }

    private void handleSearch(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String query = req.getParameter("q");
        List<Produit> produits = produitService.search(query);
        req.setAttribute("produits", produits);
        req.setAttribute("searchQuery", query);
        req.getRequestDispatcher("/WEB-INF/jsp/produits.jsp").forward(req, resp);
    }
}

