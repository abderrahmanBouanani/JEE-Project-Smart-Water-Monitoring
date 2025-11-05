package services;

import dao.HistoriqueConsommationDao;
import model.HistoriqueConsommation;

import java.util.List;

public class HistoriqueConsommationService implements IService<HistoriqueConsommation> {

    private final HistoriqueConsommationDao historiqueConsommationDao = new HistoriqueConsommationDao();

    @Override
    public boolean create(HistoriqueConsommation o) {
        return historiqueConsommationDao.create(o);
    }

    @Override
    public boolean delete(HistoriqueConsommation o) {
        return historiqueConsommationDao.delete(o);
    }

    @Override
    public boolean update(HistoriqueConsommation o) {
        return historiqueConsommationDao.update(o);
    }

    @Override
    public List<HistoriqueConsommation> findAll() {
        return historiqueConsommationDao.findAll();
    }

    @Override
    public HistoriqueConsommation findById(Long id) {
        return historiqueConsommationDao.findById(id);
    }
}
