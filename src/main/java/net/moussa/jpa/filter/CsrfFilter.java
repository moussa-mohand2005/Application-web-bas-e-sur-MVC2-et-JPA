package net.moussa.jpa.filter;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.UUID;

@WebFilter("/*")
public class CsrfFilter implements Filter {

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;
        HttpSession session = req.getSession(true);
        
        String token = (String) session.getAttribute("csrfToken");
        if (token == null) {
            token = UUID.randomUUID().toString();
            session.setAttribute("csrfToken", token);
        }
        
        if ("POST".equalsIgnoreCase(req.getMethod())) {
            String requestToken = req.getParameter("csrfToken");
            if (requestToken == null || !requestToken.equals(token)) {
                resp.sendError(HttpServletResponse.SC_FORBIDDEN, "CSRF token invalide");
                return;
            }
        }
        
        chain.doFilter(request, response);
    }
}

