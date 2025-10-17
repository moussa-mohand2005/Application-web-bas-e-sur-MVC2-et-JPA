package net.moussa.jpa.service;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import net.moussa.jpa.entities.Produit;
import net.moussa.jpa.entities.Internaute;
import net.moussa.jpa.repository.ProduitRepository;
import java.util.List;
import java.util.Optional;

@ApplicationScoped
public class ProduitService {
    
    @Inject
    private ProduitRepository produitRepository;

    public List<Produit> findAll() {
        return produitRepository.findAll();
    }

    public Optional<Produit> findById(Long id) {
        return produitRepository.findById(id);
    }

    public List<Produit> search(String keyword) {
        if (keyword == null || keyword.trim().isEmpty()) {
            return findAll();
        }
        return produitRepository.searchByKeyword(keyword.trim());
    }

    @Transactional
    public Produit create(Produit produit) {
        produitRepository.save(produit);
        return produit;
    }

    @Transactional
    public Produit update(Produit produit) {
        return produitRepository.update(produit);
    }

    @Transactional
    public void delete(Long id) {
        Optional<Produit> produitOpt = produitRepository.findById(id);
        if (produitOpt.isPresent()) {
            produitRepository.delete(produitOpt.get());
        }
    }

    public List<Produit> findAllForAdmin() {
        return produitRepository.findAllForAdmin();
    }

    public List<Produit> findByVendeur(Long vendeurId) {
        return produitRepository.findByVendeur(vendeurId);
    }

    @Transactional
    public Produit createForVendeur(Internaute vendeur, Produit produit) {
        produit.setVendeur(vendeur);
        produitRepository.save(produit);
        return produit;
    }
}

