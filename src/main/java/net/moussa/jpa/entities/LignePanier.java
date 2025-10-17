package net.moussa.jpa.entities;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "ligne_panier")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class LignePanier {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private Integer quantite;
    
    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal prixUnitaire;
    
    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "produit_id", nullable = false)
    private Produit produit;
    
    @ManyToOne
    @JoinColumn(name = "panier_id", nullable = false)
    private Panier panier;

    public LignePanier(Integer quantite, BigDecimal prixUnitaire, Produit produit) {
        this.quantite = quantite;
        this.prixUnitaire = prixUnitaire;
        this.produit = produit;
    }

    public BigDecimal getSousTotal() {
        return prixUnitaire.multiply(new BigDecimal(quantite));
    }
}

