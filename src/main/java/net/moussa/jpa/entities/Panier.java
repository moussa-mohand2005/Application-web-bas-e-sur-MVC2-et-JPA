package net.moussa.jpa.entities;

import jakarta.persistence.*;
import lombok.*;
import java.math.BigDecimal;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "panier")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Panier {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private StatutPanier statut = StatutPanier.OUVERT;
    
    @Column(precision = 10, scale = 2)
    private BigDecimal total = BigDecimal.ZERO;
    
    @OneToMany(mappedBy = "panier", cascade = CascadeType.ALL, orphanRemoval = true, fetch = FetchType.EAGER)
    private List<LignePanier> lignes = new ArrayList<>();
    
    @OneToOne
    @JoinColumn(name = "internaute_id")
    private Internaute internaute;

    public Panier(StatutPanier statut) {
        this.statut = statut;
    }

    public void addLigne(LignePanier ligne) {
        lignes.add(ligne);
        ligne.setPanier(this);
    }

    public void removeLigne(LignePanier ligne) {
        lignes.remove(ligne);
        ligne.setPanier(null);
    }
}

