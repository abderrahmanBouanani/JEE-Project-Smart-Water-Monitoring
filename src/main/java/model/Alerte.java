package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "alertes")
public class Alerte {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idAlerte;

    @Enumerated(EnumType.STRING)
    @Column(nullable = true, length = 20)
    private TypeAlerte type;

    @Column(nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private LocalDateTime dateCreation;

    private boolean estLue;

    @Column(nullable = false)
    private String message;

    @Column(length = 20)
    private String niveauUrgence;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "utilisateur_id", nullable = false)
    private Utilisateur utilisateur;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "donnee_capteur_id")
    private DonneeCapteur donneeCapteur;

    // Constructeurs
    public Alerte() {}

    public Alerte(TypeAlerte type, String message, String niveauUrgence, Utilisateur utilisateur) {
        this.type = type;
        this.dateCreation = LocalDateTime.now();
        this.estLue = false;
        this.message = message;
        this.niveauUrgence = niveauUrgence;
        this.utilisateur = utilisateur;
    }

    // Getters et Setters

    public Long getIdAlerte() {
        return idAlerte;
    }

    public void setIdAlerte(Long idAlerte) {
        this.idAlerte = idAlerte;
    }

    public TypeAlerte getType() {
        return type;
    }

    public void setType(TypeAlerte type) {
        this.type = type;
    }

    public LocalDateTime getDateCreation() {
        return dateCreation;
    }

    public void setDateCreation(LocalDateTime dateCreation) {
        this.dateCreation = dateCreation;
    }

    public boolean isEstLue() {
        return estLue;
    }

    public void setEstLue(boolean estLue) {
        this.estLue = estLue;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public String getNiveauUrgence() {
        return niveauUrgence;
    }

    public void setNiveauUrgence(String niveauUrgence) {
        this.niveauUrgence = niveauUrgence;
    }

    public Utilisateur getUtilisateur() {
        return utilisateur;
    }

    public void setUtilisateur(Utilisateur utilisateur) {
        this.utilisateur = utilisateur;
    }

    public DonneeCapteur getDonneeCapteur() {
        return donneeCapteur;
    }

    public void setDonneeCapteur(DonneeCapteur donneeCapteur) {
        this.donneeCapteur = donneeCapteur;
    }
}
