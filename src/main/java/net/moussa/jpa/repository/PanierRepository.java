package net.moussa.jpa.repository;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import net.moussa.jpa.entities.Internaute;
import net.moussa.jpa.entities.Panier;
import net.moussa.jpa.entities.StatutPanier;
import java.util.Optional;

@ApplicationScoped
public class PanierRepository {
    
    @PersistenceContext(unitName = "maPU")
    private EntityManager em;

    public void save(Panier panier) {
        em.persist(panier);
    }

    public Panier update(Panier panier) {
        return em.merge(panier);
    }

    public Optional<Panier> findById(Long id) {
        Panier panier = em.find(Panier.class, id);
        return Optional.ofNullable(panier);
    }

    public Optional<Panier> findActiveByInternaute(Internaute internaute) {
        TypedQuery<Panier> query = em.createQuery(
            "SELECT p FROM Panier p WHERE p.internaute = :internaute AND p.statut = :statut", 
            Panier.class);
        query.setParameter("internaute", internaute);
        query.setParameter("statut", StatutPanier.OUVERT);
        return query.getResultList().stream().findFirst();
    }
}

