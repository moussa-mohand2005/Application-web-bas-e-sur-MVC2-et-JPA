package net.moussa.jpa.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;

@WebFilter({"/panier", "/admin/*"})
public class AuthFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(false);
        
        Long userId = null;
        if (session != null) {
            userId = (Long) session.getAttribute("userId");
        }
        
        if (userId == null) {
            String requestURI = req.getRequestURI();
            String contextPath = req.getContextPath();
            String path = requestURI.substring(contextPath.length());
            resp.sendRedirect(contextPath + "/auth?action=login&redirect=" + path);
        } else {
            chain.doFilter(request, response);
        }
    }
}

