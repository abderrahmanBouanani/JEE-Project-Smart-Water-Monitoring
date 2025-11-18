package services;

import dao.DonneeCapteurDao;
import model.DonneeCapteur;

import java.util.List;

public class DonneeCapteurService implements IService<DonneeCapteur> {

    private DonneeCapteurDao donneeCapteurDao = new DonneeCapteurDao();

    @Override
    public boolean create(DonneeCapteur o) {
        return donneeCapteurDao.create(o);
    }

    @Override
    public boolean delete(DonneeCapteur o) {
        return donneeCapteurDao.delete(o);
    }

    @Override
    public boolean update(DonneeCapteur o) {
        return donneeCapteurDao.update(o);
    }

    @Override
    public List<DonneeCapteur> findAll() {
        return donneeCapteurDao.findAll();
    }

    @Override
    public DonneeCapteur findById(Long id) {
        return donneeCapteurDao.findById(id);
    }

    // Dans DonneeCapteurService.java - ajoute cette méthode
    public List<DonneeCapteur> findRecentByUserId(Long userId) {
        return donneeCapteurDao.findRecentByUserId(userId);
    }

    /**
     * Récupère la consommation quotidienne des 7 derniers jours
     */
    public List<Double> getDailyConsumptionLast7Days(Long userId) {
        return donneeCapteurDao.getDailyConsumptionLast7Days(userId);
    }

    public long countAll() {
        return donneeCapteurDao.countAll();
    }

    public double getTotalConsumption() {
        return donneeCapteurDao.getTotalConsumption();
    }

    public double getAverageConsumption() {
        return donneeCapteurDao.getAverageConsumption();
    }

    /**
     * Récupère la consommation mensuelle des 6 derniers mois
     */
    public List<Double> getMonthlyConsumptionLast6Months(Long userId) {
        return donneeCapteurDao.getMonthlyConsumptionLast6Months(userId);
    }
}
