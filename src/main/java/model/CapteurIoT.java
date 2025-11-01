package model;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "capteurs")
public class CapteurIoT {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idCapteur;

    @Column(unique = true, nullable = false, length = 100)
    private String reference;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false, length = 20)
    private TypeCapteur type;

    @Column(length = 100)
    private String emplacement;

    private boolean etat;

    private LocalDate dateInstallation;

    private double seuilAlerte;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "utilisateur_id", nullable = false)
    private Utilisateur utilisateur;

    // Constructeurs
    public CapteurIoT() {}

    public CapteurIoT(String reference, TypeCapteur type, String emplacement, Utilisateur utilisateur) {
        this.reference = reference;
        this.type = type;
        this.emplacement = emplacement;
        this.utilisateur = utilisateur;
        this.etat = true;
        this.dateInstallation = LocalDate.now();
    }

    // Getters et Setters

    public Long getIdCapteur() {
        return idCapteur;
    }

    public void setIdCapteur(Long idCapteur) {
        this.idCapteur = idCapteur;
    }

    public String getReference() {
        return reference;
    }

    public void setReference(String reference) {
        this.reference = reference;
    }

    public TypeCapteur getType() {
        return type;
    }

    public void setType(TypeCapteur type) {
        this.type = type;
    }

    public String getEmplacement() {
        return emplacement;
    }

    public void setEmplacement(String emplacement) {
        this.emplacement = emplacement;
    }

    public boolean isEtat() {
        return etat;
    }

    public void setEtat(boolean etat) {
        this.etat = etat;
    }

    public LocalDate getDateInstallation() {
        return dateInstallation;
    }

    public void setDateInstallation(LocalDate dateInstallation) {
        this.dateInstallation = dateInstallation;
    }

    public double getSeuilAlerte() {
        return seuilAlerte;
    }

    public void setSeuilAlerte(double seuilAlerte) {
        this.seuilAlerte = seuilAlerte;
    }

    public Utilisateur getUtilisateur() {
        return utilisateur;
    }

    public void setUtilisateur(Utilisateur utilisateur) {
        this.utilisateur = utilisateur;
    }
}
