package model;

import jakarta.persistence.*;
import java.time.LocalDateTime;

@Entity
@Table(name = "donnees_capteur")
public class DonneeCapteur {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idDonnee;

    @Column(nullable = false)
    @Temporal(TemporalType.TIMESTAMP)
    private LocalDateTime horodatage;

    @Column(nullable = false)
    private double valeurConsommation;

    @Column(length = 20)
    private String unite;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "capteur_id", nullable = false)
    private CapteurIoT capteur;

    // Constructeurs
    public DonneeCapteur() {}

    public DonneeCapteur(double valeurConsommation, String unite, CapteurIoT capteur) {
        this.horodatage = LocalDateTime.now();
        this.valeurConsommation = valeurConsommation;
        this.unite = unite;
        this.capteur = capteur;
    }

    // Getters et Setters

    public Long getIdDonnee() {
        return idDonnee;
    }

    public void setIdDonnee(Long idDonnee) {
        this.idDonnee = idDonnee;
    }

    public LocalDateTime getHorodatage() {
        return horodatage;
    }

    public void setHorodatage(LocalDateTime horodatage) {
        this.horodatage = horodatage;
    }

    public double getValeurConsommation() {
        return valeurConsommation;
    }

    public void setValeurConsommation(double valeurConsommation) {
        this.valeurConsommation = valeurConsommation;
    }

    public String getUnite() {
        return unite;
    }

    public void setUnite(String unite) {
        this.unite = unite;
    }

    public CapteurIoT getCapteur() {
        return capteur;
    }

    public void setCapteur(CapteurIoT capteur) {
        this.capteur = capteur;
    }
}
