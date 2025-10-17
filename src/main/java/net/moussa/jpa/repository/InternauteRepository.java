package net.moussa.jpa.repository;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import net.moussa.jpa.entities.Internaute;
import net.moussa.jpa.entities.Role;
import java.util.Optional;
import java.util.List;

@ApplicationScoped
public class InternauteRepository {
    
    @PersistenceContext(unitName = "maPU")
    private EntityManager em;

    public void save(Internaute internaute) {
        em.persist(internaute);
    }

    public Internaute update(Internaute internaute) {
        return em.merge(internaute);
    }

    public void delete(Long id) {
        Internaute internaute = em.find(Internaute.class, id);
        if (internaute != null) {
            em.remove(internaute);
        }
    }

    public Optional<Internaute> findById(Long id) {
        Internaute internaute = em.find(Internaute.class, id);
        return Optional.ofNullable(internaute);
    }

    public Optional<Internaute> findByEmail(String email) {
        TypedQuery<Internaute> query = em.createQuery(
            "SELECT i FROM Internaute i WHERE i.email = :email", Internaute.class);
        query.setParameter("email", email);
        return query.getResultList().stream().findFirst();
    }

    public boolean existsByEmail(String email) {
        TypedQuery<Long> query = em.createQuery(
            "SELECT COUNT(i) FROM Internaute i WHERE i.email = :email", Long.class);
        query.setParameter("email", email);
        return query.getSingleResult() > 0;
    }

    public List<Internaute> findAll() {
        TypedQuery<Internaute> query = em.createQuery(
            "SELECT i FROM Internaute i ORDER BY i.id DESC", Internaute.class);
        return query.getResultList();
    }

    public List<Internaute> findByRole(Role role) {
        TypedQuery<Internaute> query = em.createQuery(
            "SELECT i FROM Internaute i WHERE i.role = :role ORDER BY i.id DESC", Internaute.class);
        query.setParameter("role", role);
        return query.getResultList();
    }
}

