package services;

import dao.ObjectifConsommationDao;
import model.ObjectifConsommation;

import java.util.List;

public class ObjectifConsommationService implements IService<ObjectifConsommation> {

    private final ObjectifConsommationDao objectifConsommationDao = new ObjectifConsommationDao();

    @Override
    public boolean create(ObjectifConsommation o) {
        return objectifConsommationDao.create(o);
    }

    @Override
    public boolean delete(ObjectifConsommation o) {
        return objectifConsommationDao.delete(o);
    }

    @Override
    public boolean update(ObjectifConsommation o) {
        return objectifConsommationDao.update(o);
    }

    @Override
    public List<ObjectifConsommation> findAll() {
        return objectifConsommationDao.findAll();
    }

    @Override
    public ObjectifConsommation findById(Long id) {
        return objectifConsommationDao.findById(id);
    }
}
