package services;

import dao.UtilisateurDao;
import model.Utilisateur;

import java.util.List;

public class UtilisateurService implements IService<Utilisateur> {

    private final UtilisateurDao utilisateurDao = new UtilisateurDao();

    @Override
    public boolean create(Utilisateur o) {
        return utilisateurDao.create(o);
    }

    @Override
    public boolean delete(Utilisateur o) {
        return utilisateurDao.delete(o);
    }

    @Override
    public boolean update(Utilisateur o) {
        return utilisateurDao.update(o);
    }

    @Override
    public List<Utilisateur> findAll() {
        return utilisateurDao.findAll();
    }

    @Override
    public Utilisateur findById(Long id) {
        return utilisateurDao.findById(id);
    }
}
