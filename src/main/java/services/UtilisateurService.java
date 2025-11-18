package services;

import dao.UtilisateurDao;
import model.Utilisateur;
import model.TypeUtilisateur;

import java.util.List;

public class UtilisateurService implements IService<Utilisateur> {

    private UtilisateurDao utilisateurDao = new UtilisateurDao();

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
    public Utilisateur findById(Long id) { // Changé pour Long
        return utilisateurDao.findById(id);
    }

    // Nouvelle méthode pour l'authentification
    public Utilisateur findByEmail(String email) {
        return utilisateurDao.findByEmail(email);
    }

    public long countAll() {
        return utilisateurDao.countAll();
    }

    public long countByType(TypeUtilisateur type) {
        return utilisateurDao.countByType(type);
    }
}
