package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "statistiques")
public class Statistique {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idStatistique;

    @Column(length = 50)
    private String type;

    private double valeur;

    @Column(length = 50)
    private String periode;

    @Column(nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private LocalDateTime dateGeneration;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "utilisateur_id", nullable = false)
    private Utilisateur utilisateur;

    // Constructeurs
    public Statistique() {}

    public Statistique(String type, double valeur, String periode, Utilisateur utilisateur) {
        this.type = type;
        this.valeur = valeur;
        this.periode = periode;
        this.dateGeneration = LocalDateTime.now();
        this.utilisateur = utilisateur;
    }

    // Getters et Setters

    public Long getIdStatistique() {
        return idStatistique;
    }

    public void setIdStatistique(Long idStatistique) {
        this.idStatistique = idStatistique;
    }

    public String getType() {
        return type;
    }

    public void setType(String type) {
        this.type = type;
    }

    public double getValeur() {
        return valeur;
    }

    public void setValeur(double valeur) {
        this.valeur = valeur;
    }

    public String getPeriode() {
        return periode;
    }

    public void setPeriode(String periode) {
        this.periode = periode;
    }

    public LocalDateTime getDateGeneration() {
        return dateGeneration;
    }

    public void setDateGeneration(LocalDateTime dateGeneration) {
        this.dateGeneration = dateGeneration;
    }

    public Utilisateur getUtilisateur() {
        return utilisateur;
    }

    public void setUtilisateur(Utilisateur utilisateur) {
        this.utilisateur = utilisateur;
    }
}
