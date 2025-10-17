package net.moussa.jpa.service;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import net.moussa.jpa.entities.Internaute;
import net.moussa.jpa.entities.Role;
import net.moussa.jpa.repository.InternauteRepository;
import java.util.List;
import java.util.Optional;

@ApplicationScoped
public class UserService {

    @Inject
    private InternauteRepository internauteRepository;

    public List<Internaute> findAll() {
        return internauteRepository.findAll();
    }

    public List<Internaute> findByRole(Role role) {
        return internauteRepository.findByRole(role);
    }

    public Optional<Internaute> findById(Long id) {
        return internauteRepository.findById(id);
    }

    @Transactional
    public void changeRole(Long userId, Role role) {
        Optional<Internaute> userOpt = internauteRepository.findById(userId);
        if (userOpt.isPresent()) {
            Internaute u = userOpt.get();
            u.setRole(role);
            internauteRepository.update(u);
        }
    }

    @Transactional
    public void deleteUser(Long userId) {
        internauteRepository.delete(userId);
    }
}
