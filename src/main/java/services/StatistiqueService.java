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
}
