package net.moussa.jpa.service;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import net.moussa.jpa.entities.Internaute;
import net.moussa.jpa.repository.InternauteRepository;
import org.mindrot.jbcrypt.BCrypt;
import java.util.Optional;

@ApplicationScoped
public class AuthService {
    
    @Inject
    private InternauteRepository internauteRepository;

    @Transactional
    public Internaute register(String nom, String email, String password, String adresse, String telephone) {
        if (internauteRepository.existsByEmail(email)) {
            throw new IllegalArgumentException("Email déjà utilisé");
        }
        
        String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
        Internaute internaute = new Internaute(nom, email, hashedPassword, adresse, telephone);
        internauteRepository.save(internaute);
        return internaute;
    }

    public Optional<Internaute> authenticate(String email, String password) {
        Optional<Internaute> internauteOpt = internauteRepository.findByEmail(email);
        
        if (internauteOpt.isPresent()) {
            Internaute internaute = internauteOpt.get();
            if (BCrypt.checkpw(password, internaute.getMotDePasse())) {
                return Optional.of(internaute);
            }
        }
        return Optional.empty();
    }

    public Optional<Internaute> findById(Long id) {
        return internauteRepository.findById(id);
    }
}

