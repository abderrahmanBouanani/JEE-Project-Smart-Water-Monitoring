package services;

import dao.AlerteDao;
import model.Alerte;
import java.util.List;

public class AlerteService implements IService<Alerte> {

    private final AlerteDao alerteDao = new AlerteDao();

    @Override
    public boolean create(Alerte o) {
        return alerteDao.create(o);
    }

    @Override
    public boolean delete(Alerte o) {
        return alerteDao.delete(o);
    }

    @Override
    public boolean update(Alerte o) {
        return alerteDao.update(o);
    }

    @Override
    public List<Alerte> findAll() {
        return alerteDao.findAll();
    }

    @Override
    public Alerte findById(Long id) {
        return alerteDao.findById(id);
    }

    // NOUVELLES MÉTHODES
    public List<Alerte> findByUserId(Long userId) {
        return alerteDao.findByUserId(userId);
    }

    public List<Alerte> findUnreadByUserId(Long userId) {
        return alerteDao.findUnreadByUserId(userId);
    }

    public int countUnreadByUserId(Long userId) {
        return alerteDao.findUnreadByUserId(userId).size();
    }

    public boolean marquerCommeLue(Long alerteId, Long userId) {
        Alerte alerte = findById(alerteId);
        // Vérifier que l'alerte appartient bien à l'utilisateur
        if (alerte != null && alerte.getUtilisateur().getIdUtilisateur().equals(userId)) {
            alerte.setEstLue(true);
            return update(alerte);
        }
        return false;
    }

    public boolean archiverAlerte(Long alerteId, Long userId) {
        Alerte alerte = findById(alerteId);
        // Vérifier que l'alerte appartient bien à l'utilisateur
        if (alerte != null && alerte.getUtilisateur().getIdUtilisateur().equals(userId)) {
            return delete(alerte);
        }
        return false;
    }

    public boolean toutMarquerCommeLu(Long userId) {
        List<Alerte> alertesNonLues = findUnreadByUserId(userId);
        boolean success = true;
        for (Alerte alerte : alertesNonLues) {
            alerte.setEstLue(true);
            if (!update(alerte)) {
                success = false;
            }
        }
        return success;
    }
}