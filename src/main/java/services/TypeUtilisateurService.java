package services;

import dao.TypeUtilisateurDao;
import model.TypeUtilisateur;

import java.util.List;

public class TypeUtilisateurService implements IService<TypeUtilisateur> {

    private final TypeUtilisateurDao typeUtilisateurDao = new TypeUtilisateurDao();

    @Override
    public boolean create(TypeUtilisateur o) {
        return typeUtilisateurDao.create(o);
    }

    @Override
    public boolean delete(TypeUtilisateur o) {
        return typeUtilisateurDao.delete(o);
    }

    @Override
    public boolean update(TypeUtilisateur o) {
        return typeUtilisateurDao.update(o);
    }

    @Override
    public List<TypeUtilisateur> findAll() {
        return typeUtilisateurDao.findAll();
    }

    @Override
    public TypeUtilisateur findById(Long id) {
        return typeUtilisateurDao.findById(id);
    }
}
