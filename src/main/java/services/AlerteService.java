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
}