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
}
