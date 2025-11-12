package model;

import jakarta.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "historiques_consommation")
public class HistoriqueConsommation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idHistorique;

    @Temporal(TemporalType.DATE)
    private LocalDate date;

    private double volumeTotal;

    private double coutEstime;

    private double consommationMoyenne;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "utilisateur_id", nullable = false)
    private Utilisateur utilisateur;

    // Constructeurs
    public HistoriqueConsommation() {}

    public HistoriqueConsommation(LocalDate date, double volumeTotal, double coutEstime, double consommationMoyenne, Utilisateur utilisateur) {
        this.date = date;
        this.volumeTotal = volumeTotal;
        this.coutEstime = coutEstime;
        this.consommationMoyenne = consommationMoyenne;
        this.utilisateur = utilisateur;
    }

    // Getters et Setters

    public Long getIdHistorique() {
        return idHistorique;
    }

    public void setIdHistorique(Long idHistorique) {
        this.idHistorique = idHistorique;
    }

    public LocalDate getDate() {
        return date;
    }

    public void setDate(LocalDate date) {
        this.date = date;
    }

    public double getVolumeTotal() {
        return volumeTotal;
    }

    public void setVolumeTotal(double volumeTotal) {
        this.volumeTotal = volumeTotal;
    }

    public double getCoutEstime() {
        return coutEstime;
    }

    public void setCoutEstime(double coutEstime) {
        this.coutEstime = coutEstime;
    }

    public double getConsommationMoyenne() {
        return consommationMoyenne;
    }

    public void setConsommationMoyenne(double consommationMoyenne) {
        this.consommationMoyenne = consommationMoyenne;
    }

    public Utilisateur getUtilisateur() {
        return utilisateur;
    }

    public void setUtilisateur(Utilisateur utilisateur) {
        this.utilisateur = utilisateur;
    }
}
