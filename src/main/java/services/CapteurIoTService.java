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
}
