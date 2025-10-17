package net.moussa.jpa.web;

import jakarta.inject.Inject;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import net.moussa.jpa.entities.Role;
import net.moussa.jpa.service.UserService;
import java.io.IOException;

@WebServlet("/admin/users")
public class AdminUserServlet extends HttpServlet {

    @Inject
    private UserService userService;

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        
        if ("details".equals(action)) {
            String idParam = req.getParameter("id");
            if (idParam != null) {
                Long id = Long.parseLong(idParam);
                userService.findById(id).ifPresent(user -> req.setAttribute("selectedUser", user));
            }
        }
        
        req.setAttribute("users", userService.findAll());
        req.setAttribute("roles", Role.values());
        req.getRequestDispatcher("/WEB-INF/jsp/admin-users.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("changeRole".equals(action)) {
            Long id = Long.parseLong(req.getParameter("id"));
            Role role = Role.valueOf(req.getParameter("role"));
            userService.changeRole(id, role);
        } else if ("delete".equals(action)) {
            Long id = Long.parseLong(req.getParameter("id"));
            userService.deleteUser(id);
        }
        resp.sendRedirect(req.getContextPath() + "/admin/users");
    }
}
