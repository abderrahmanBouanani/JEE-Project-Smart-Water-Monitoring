package services;

import dao.StatistiqueDao;
import model.Statistique;
import java.util.List;

public class StatistiqueService implements IService<Statistique> {

    private final StatistiqueDao statistiqueDao = new StatistiqueDao();

    @Override
    public boolean create(Statistique o) {
        return statistiqueDao.create(o);
    }

    @Override
    public boolean delete(Statistique o) {
        return statistiqueDao.delete(o);
    }

    @Override
    public boolean update(Statistique o) {
        return statistiqueDao.update(o);
    }

    @Override
    public List<Statistique> findAll() {
        return statistiqueDao.findAll();
    }

    @Override
    public Statistique findById(Long id) {
        return statistiqueDao.findById(id);
    }

    // ✅ NOUVELLES MÉTHODES
    public List<Statistique> findByUserId(Long userId) {
        return statistiqueDao.findByUserId(userId);
    }

    public List<Statistique> findByTypeAndUserId(String type, Long userId) {
        return statistiqueDao.findByTypeAndUserId(type, userId);
    }

    // Méthode utilitaire pour les statistiques de consommation moyenne
    public Double getConsommationMoyenneByUserId(Long userId) {
        List<Statistique> stats = findByTypeAndUserId("CONSOMMATION_MOYENNE", userId);
        if (!stats.isEmpty()) {
            return stats.get(0).getValeur();
        }
        return null;
    }

    // Méthode utilitaire pour les statistiques de consommation totale
    public Double getConsommationTotaleByUserId(Long userId) {
        List<Statistique> stats = findByTypeAndUserId("CONSOMMATION_TOTALE", userId);
        if (!stats.isEmpty()) {
            return stats.get(0).getValeur();
        }
        return null;
    }
}