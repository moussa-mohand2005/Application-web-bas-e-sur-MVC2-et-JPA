package net.moussa.jpa.repository;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import net.moussa.jpa.entities.Vitrine;
import java.util.Optional;

@ApplicationScoped
public class VitrineRepository {
    
    @PersistenceContext(unitName = "maPU")
    private EntityManager em;

    public void save(Vitrine vitrine) {
        em.persist(vitrine);
    }

    public Vitrine update(Vitrine vitrine) {
        return em.merge(vitrine);
    }

    public Optional<Vitrine> findById(Long id) {
        Vitrine vitrine = em.find(Vitrine.class, id);
        return Optional.ofNullable(vitrine);
    }

    public Optional<Vitrine> findFirst() {
        TypedQuery<Vitrine> query = em.createQuery(
            "SELECT v FROM Vitrine v ORDER BY v.id", Vitrine.class);
        query.setMaxResults(1);
        return query.getResultList().stream().findFirst();
    }
}

