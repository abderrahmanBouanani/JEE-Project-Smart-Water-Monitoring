package model;

import javax.persistence.*;
import java.time.LocalDate;

@Entity
@Table(name = "objectifs_consommation")
public class ObjectifConsommation {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long idObjectif;

    private double seuilMaximum;

    @Column(length = 50)
    private String periode;

    private LocalDate dateDebut;

    private LocalDate dateFin;

    private boolean estAtteint;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "utilisateur_id", nullable = false)
    private Utilisateur utilisateur;

    // Constructeurs
    public ObjectifConsommation() {}

    public ObjectifConsommation(double seuilMaximum, String periode, LocalDate dateDebut, LocalDate dateFin, Utilisateur utilisateur) {
        this.seuilMaximum = seuilMaximum;
        this.periode = periode;
        this.dateDebut = dateDebut;
        this.dateFin = dateFin;
        this.utilisateur = utilisateur;
        this.estAtteint = false;
    }

    // Getters et Setters

    public Long getIdObjectif() {
        return idObjectif;
    }

    public void setIdObjectif(Long idObjectif) {
        this.idObjectif = idObjectif;
    }

    public double getSeuilMaximum() {
        return seuilMaximum;
    }

    public void setSeuilMaximum(double seuilMaximum) {
        this.seuilMaximum = seuilMaximum;
    }

    public String getPeriode() {
        return periode;
    }

    public void setPeriode(String periode) {
        this.periode = periode;
    }

    public LocalDate getDateDebut() {
        return dateDebut;
    }

    public void setDateDebut(LocalDate dateDebut) {
        this.dateDebut = dateDebut;
    }

    public LocalDate getDateFin() {
        return dateFin;
    }

    public void setDateFin(LocalDate dateFin) {
        this.dateFin = dateFin;
    }

    public boolean isEstAtteint() {
        return estAtteint;
    }

    public void setEstAtteint(boolean estAtteint) {
        this.estAtteint = estAtteint;
    }

    public Utilisateur getUtilisateur() {
        return utilisateur;
    }

    public void setUtilisateur(Utilisateur utilisateur) {
        this.utilisateur = utilisateur;
    }
}
