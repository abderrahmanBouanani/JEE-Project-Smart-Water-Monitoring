package services;

import dao.TypeCapteurDao;
import model.TypeCapteur;

import java.util.List;

public class TypeCapteurService implements IService<TypeCapteur> {

    private final TypeCapteurDao typeCapteurDao = new TypeCapteurDao();

    @Override
    public boolean create(TypeCapteur o) {
        return typeCapteurDao.create(o);
    }

    @Override
    public boolean delete(TypeCapteur o) {
        return typeCapteurDao.delete(o);
    }

    @Override
    public boolean update(TypeCapteur o) {
        return typeCapteurDao.update(o);
    }

    @Override
    public List<TypeCapteur> findAll() {
        return typeCapteurDao.findAll();
    }

    @Override
    public TypeCapteur findById(Long id) {
        return typeCapteurDao.findById(id);
    }
}
