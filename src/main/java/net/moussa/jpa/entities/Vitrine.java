package net.moussa.jpa.entities;

import jakarta.persistence.*;
import lombok.*;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "vitrine")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Vitrine {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String titre;
    
    @Column(length = 1000)
    private String description;
    
    @OneToMany(mappedBy = "vitrine", cascade = CascadeType.ALL)
    private List<Produit> produits = new ArrayList<>();

    public Vitrine(String titre, String description) {
        this.titre = titre;
        this.description = description;
    }
}

