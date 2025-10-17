package net.moussa.jpa.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter({"/seller/*"})
public class SellerFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        String role = session != null ? (String) session.getAttribute("role") : null;
        if (!"VENDEUR".equals(role) && !"ADMIN".equals(role)) {
            resp.sendRedirect(req.getContextPath() + "/produits?action=list");
            return;
        }
        chain.doFilter(request, response);
    }
}
