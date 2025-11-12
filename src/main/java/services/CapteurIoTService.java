package services;

import dao.CapteurIoTDao;
import model.CapteurIoT;
import java.util.List;

public class CapteurIoTService implements IService<CapteurIoT> {

    private final CapteurIoTDao capteurIoTDao = new CapteurIoTDao();

    @Override
    public boolean create(CapteurIoT o) {
        return capteurIoTDao.create(o);
    }

    @Override
    public boolean delete(CapteurIoT o) {
        return capteurIoTDao.delete(o);
    }

    @Override
    public boolean update(CapteurIoT o) {
        return capteurIoTDao.update(o);
    }

    @Override
    public List<CapteurIoT> findAll() {
        return capteurIoTDao.findAll();
    }

    @Override
    public CapteurIoT findById(Long id) {
        return capteurIoTDao.findById(id);
    }

    // ✅ NOUVELLES MÉTHODES
    public List<CapteurIoT> findByUserId(Long userId) {
        return capteurIoTDao.findByUserId(userId);
    }

    public long countActiveByUserId(Long userId) {
        return capteurIoTDao.countActiveByUserId(userId);
    }

    public long countTotalByUserId(Long userId) {
        List<CapteurIoT> capteurs = findByUserId(userId);
        return capteurs.size();
    }
}