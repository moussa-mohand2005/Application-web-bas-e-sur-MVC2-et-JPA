package net.moussa.jpa.service;

import jakarta.enterprise.context.ApplicationScoped;
import jakarta.inject.Inject;
import jakarta.transaction.Transactional;
import net.moussa.jpa.entities.*;
import net.moussa.jpa.repository.InternauteRepository;
import net.moussa.jpa.repository.PanierRepository;
import net.moussa.jpa.repository.ProduitRepository;
import java.math.BigDecimal;
import java.util.Optional;

@ApplicationScoped
public class PanierService {
    
    @Inject
    private PanierRepository panierRepository;
    
    @Inject
    private ProduitRepository produitRepository;
    
    @Inject
    private InternauteRepository internauteRepository;

    @Transactional
    public Panier getOrCreatePanierActif(Internaute internaute) {
        Optional<Panier> panierOpt = panierRepository.findActiveByInternaute(internaute);
        
        if (panierOpt.isPresent()) {
            return panierOpt.get();
        }
        
        Panier panier = new Panier(StatutPanier.OUVERT);
        panier.setInternaute(internaute);
        panierRepository.save(panier);
        internaute.setPanierActif(panier);
        internauteRepository.update(internaute);
        return panier;
    }

    @Transactional
    public void add(Internaute internaute, Long produitId, int quantite) {
        Panier panier = getOrCreatePanierActif(internaute);
        Produit produit = produitRepository.findById(produitId)
            .orElseThrow(() -> new IllegalArgumentException("Produit introuvable"));
        
        if (!produit.getActif()) {
            throw new IllegalArgumentException("Produit non disponible");
        }
        
        if (produit.getStock() < quantite) {
            throw new IllegalArgumentException("Stock insuffisant");
        }
        
        Optional<LignePanier> ligneExistante = panier.getLignes().stream()
            .filter(l -> l.getProduit().getId().equals(produitId))
            .findFirst();
        
        if (ligneExistante.isPresent()) {
            LignePanier ligne = ligneExistante.get();
            int nouvelleQuantite = ligne.getQuantite() + quantite;
            
            if (produit.getStock() < nouvelleQuantite) {
                throw new IllegalArgumentException("Stock insuffisant");
            }
            
            ligne.setQuantite(nouvelleQuantite);
        } else {
            LignePanier nouvelleLigne = new LignePanier(quantite, produit.getPrix(), produit);
            panier.addLigne(nouvelleLigne);
        }
        
        calculerTotal(panier);
        panierRepository.update(panier);
    }

    @Transactional
    public void updateQuantite(Internaute internaute, Long produitId, int quantite) {
        Panier panier = getOrCreatePanierActif(internaute);
        
        if (quantite <= 0) {
            remove(internaute, produitId);
            return;
        }
        
        LignePanier ligne = panier.getLignes().stream()
            .filter(l -> l.getProduit().getId().equals(produitId))
            .findFirst()
            .orElseThrow(() -> new IllegalArgumentException("Produit non trouvé dans le panier"));
        
        Produit produit = ligne.getProduit();
        
        if (produit.getStock() < quantite) {
            throw new IllegalArgumentException("Stock insuffisant");
        }
        
        ligne.setQuantite(quantite);
        calculerTotal(panier);
        panierRepository.update(panier);
    }

    @Transactional
    public void remove(Internaute internaute, Long produitId) {
        Panier panier = getOrCreatePanierActif(internaute);
        
        LignePanier ligne = panier.getLignes().stream()
            .filter(l -> l.getProduit().getId().equals(produitId))
            .findFirst()
            .orElseThrow(() -> new IllegalArgumentException("Produit non trouvé dans le panier"));
        
        panier.removeLigne(ligne);
        calculerTotal(panier);
        panierRepository.update(panier);
    }

    @Transactional
    public void clear(Internaute internaute) {
        Panier panier = getOrCreatePanierActif(internaute);
        panier.getLignes().clear();
        panier.setTotal(BigDecimal.ZERO);
        panierRepository.update(panier);
    }

    @Transactional
    public void checkout(Internaute internaute) {
        Panier panier = getOrCreatePanierActif(internaute);
        
        if (panier.getLignes().isEmpty()) {
            throw new IllegalArgumentException("Le panier est vide");
        }
        
        for (LignePanier ligne : panier.getLignes()) {
            Produit produit = ligne.getProduit();
            if (produit.getStock() < ligne.getQuantite()) {
                throw new IllegalArgumentException("Stock insuffisant pour " + produit.getLibelle());
            }
            produit.setStock(produit.getStock() - ligne.getQuantite());
            produitRepository.update(produit);
        }
        
        panier.setStatut(StatutPanier.VALIDE);
        panierRepository.update(panier);
        
        Panier nouveauPanier = new Panier(StatutPanier.OUVERT);
        nouveauPanier.setInternaute(internaute);
        panierRepository.save(nouveauPanier);
        internaute.setPanierActif(nouveauPanier);
        internauteRepository.update(internaute);
    }

    private void calculerTotal(Panier panier) {
        BigDecimal total = panier.getLignes().stream()
            .map(LignePanier::getSousTotal)
            .reduce(BigDecimal.ZERO, BigDecimal::add);
        panier.setTotal(total);
    }

    public Optional<Panier> findById(Long id) {
        return panierRepository.findById(id);
    }
}

