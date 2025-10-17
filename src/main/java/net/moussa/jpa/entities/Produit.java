package net.moussa.jpa.entities;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;

@Entity
@Table(name = "produit", indexes = {
    @Index(name = "idx_libelle", columnList = "libelle"),
    @Index(name = "idx_actif", columnList = "actif")
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Produit {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String libelle;
    
    @Column(length = 2000)
    private String description;
    
    @Column(nullable = false, precision = 10, scale = 2)
    private BigDecimal prix;
    
    @Column(nullable = false)
    private Boolean actif = true;
    
    @Column(nullable = false)
    private Integer stock = 0;
    
    @ManyToOne
    @JoinColumn(name = "vitrine_id")
    private Vitrine vitrine;

    @ManyToOne
    @JoinColumn(name = "vendeur_id")
    private Internaute vendeur;

    public Produit(String libelle, String description, BigDecimal prix, Boolean actif, Integer stock) {
        this.libelle = libelle;
        this.description = description;
        this.prix = prix;
        this.actif = actif;
        this.stock = stock;
    }
}

