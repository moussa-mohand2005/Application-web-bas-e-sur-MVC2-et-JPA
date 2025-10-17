package net.moussa.jpa.repository;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.persistence.EntityManager;
import jakarta.persistence.PersistenceContext;
import jakarta.persistence.TypedQuery;
import net.moussa.jpa.entities.Produit;
import java.util.List;
import java.util.Optional;

@ApplicationScoped
public class ProduitRepository {
    
    @PersistenceContext(unitName = "maPU")
    private EntityManager em;

    public void save(Produit produit) {
        em.persist(produit);
    }

    public Produit update(Produit produit) {
        return em.merge(produit);
    }

    public void delete(Produit produit) {
        em.remove(em.contains(produit) ? produit : em.merge(produit));
    }

    public Optional<Produit> findById(Long id) {
        Produit produit = em.find(Produit.class, id);
        return Optional.ofNullable(produit);
    }

    public List<Produit> findAll() {
        TypedQuery<Produit> query = em.createQuery(
            "SELECT p FROM Produit p WHERE p.actif = true ORDER BY p.libelle", Produit.class);
        return query.getResultList();
    }

    public List<Produit> searchByKeyword(String keyword) {
        TypedQuery<Produit> query = em.createQuery(
            "SELECT p FROM Produit p WHERE p.actif = true AND " +
            "(LOWER(p.libelle) LIKE LOWER(:keyword) OR LOWER(p.description) LIKE LOWER(:keyword)) " +
            "ORDER BY p.libelle", Produit.class);
        query.setParameter("keyword", "%" + keyword + "%");
        return query.getResultList();
    }

    public List<Produit> findAllForAdmin() {
        TypedQuery<Produit> query = em.createQuery(
            "SELECT p FROM Produit p ORDER BY p.id DESC", Produit.class);
        return query.getResultList();
    }

    public List<Produit> findByVendeur(Long vendeurId) {
        TypedQuery<Produit> query = em.createQuery(
            "SELECT p FROM Produit p WHERE p.vendeur.id = :vid ORDER BY p.id DESC", Produit.class);
        query.setParameter("vid", vendeurId);
        return query.getResultList();
    }
}

