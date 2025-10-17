package net.moussa.jpa.entities;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "internaute", indexes = {
    @Index(name = "idx_email", columnList = "email", unique = true)
})
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Internaute {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String nom;
    
    @Column(nullable = false, unique = true)
    private String email;
    
    @Column(nullable = false)
    private String motDePasse;
    
    private String adresse;
    
    private String telephone;
    
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private Role role = Role.ACHETEUR;

    @OneToOne(mappedBy = "internaute", cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    private Panier panierActif;

    public Internaute(String nom, String email, String motDePasse, String adresse, String telephone) {
        this.nom = nom;
        this.email = email;
        this.motDePasse = motDePasse;
        this.adresse = adresse;
        this.telephone = telephone;
    }
}

