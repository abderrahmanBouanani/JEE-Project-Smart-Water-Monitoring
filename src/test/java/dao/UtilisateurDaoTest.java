package dao;

import model.TypeUtilisateur;
import model.Utilisateur;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class UtilisateurDaoTest {

    private UtilisateurDao utilisateurDao;

    @BeforeEach
    void setUp() {
        utilisateurDao = new UtilisateurDao();
    }

    @AfterEach
    void tearDown() {
        List<Utilisateur> utilisateurs = utilisateurDao.findAll();
        for (Utilisateur utilisateur : utilisateurs) {
            utilisateurDao.delete(utilisateur);
        }
    }

    @Test
    void testCreateAndFindById() {
        Utilisateur utilisateur = new Utilisateur("John Doe", "john.doe@example.com", "password", TypeUtilisateur.CITOYEN);
        assertTrue(utilisateurDao.create(utilisateur));

        Utilisateur foundUtilisateur = utilisateurDao.findById(utilisateur.getIdUtilisateur());
        assertNotNull(foundUtilisateur);
        assertEquals("John Doe", foundUtilisateur.getNom());
    }

    @Test
    void testFindAll() {
        Utilisateur utilisateur1 = new Utilisateur("John Doe", "john.doe@example.com", "password", TypeUtilisateur.CITOYEN);
        Utilisateur utilisateur2 = new Utilisateur("Jane Smith", "jane.smith@example.com", "password", TypeUtilisateur.ADMINISTRATEUR);
        utilisateurDao.create(utilisateur1);
        utilisateurDao.create(utilisateur2);

        List<Utilisateur> utilisateurs = utilisateurDao.findAll();
        assertNotNull(utilisateurs);
        assertEquals(2, utilisateurs.size());
    }

    @Test
    void testUpdate() {
        Utilisateur utilisateur = new Utilisateur("John Doe", "john.doe@example.com", "password", TypeUtilisateur.CITOYEN);
        utilisateurDao.create(utilisateur);

        utilisateur.setNom("Johnathan Doe");
        assertTrue(utilisateurDao.update(utilisateur));

        Utilisateur updatedUtilisateur = utilisateurDao.findById(utilisateur.getIdUtilisateur());
        assertEquals("Johnathan Doe", updatedUtilisateur.getNom());
    }

    @Test
    void testDelete() {
        Utilisateur utilisateur = new Utilisateur("John Doe", "john.doe@example.com", "password", TypeUtilisateur.CITOYEN);
        utilisateurDao.create(utilisateur);

        assertTrue(utilisateurDao.delete(utilisateur));
        Utilisateur deletedUtilisateur = utilisateurDao.findById(utilisateur.getIdUtilisateur());
        assertNull(deletedUtilisateur);
    }
}
