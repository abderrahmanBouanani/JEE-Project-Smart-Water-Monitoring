package services;

import dao.TypeAlerteDao;
import model.TypeAlerte;

import java.util.List;

public class TypeAlerteService implements IService<TypeAlerte> {

    private final TypeAlerteDao typeAlerteDao = new TypeAlerteDao();

    @Override
    public boolean create(TypeAlerte o) {
        return typeAlerteDao.create(o);
    }

    @Override
    public boolean delete(TypeAlerte o) {
        return typeAlerteDao.delete(o);
    }

    @Override
    public boolean update(TypeAlerte o) {
        return typeAlerteDao.update(o);
    }

    @Override
    public List<TypeAlerte> findAll() {
        return typeAlerteDao.findAll();
    }

    @Override
    public TypeAlerte findById(Long id) {
        return typeAlerteDao.findById(id);
    }
}
