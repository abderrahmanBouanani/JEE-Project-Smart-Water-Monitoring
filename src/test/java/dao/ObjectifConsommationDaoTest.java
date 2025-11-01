package dao;

import model.ObjectifConsommation;
import model.TypeUtilisateur;
import model.Utilisateur;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class ObjectifConsommationDaoTest {

    private ObjectifConsommationDao objectifDao;
    private UtilisateurDao utilisateurDao;
    private Utilisateur testUser;

    @BeforeEach
    void setUp() {
        objectifDao = new ObjectifConsommationDao();
        utilisateurDao = new UtilisateurDao();
        testUser = new Utilisateur("Test User", "test@example.com", "password", TypeUtilisateur.CITOYEN);
        utilisateurDao.create(testUser);
    }

    @AfterEach
    void tearDown() {
        List<ObjectifConsommation> objectifs = objectifDao.findAll();
        for (ObjectifConsommation objectif : objectifs) {
            objectifDao.delete(objectif);
        }
        utilisateurDao.delete(testUser);
    }

    @Test
    void testCreateAndFindById() {
        ObjectifConsommation objectif = new ObjectifConsommation(500.0, "Monthly", LocalDate.now(), LocalDate.now().plusMonths(1), testUser);
        assertTrue(objectifDao.create(objectif));

        ObjectifConsommation foundObjectif = objectifDao.findById(objectif.getIdObjectif());
        assertNotNull(foundObjectif);
        assertEquals(500.0, foundObjectif.getSeuilMaximum());
    }

    @Test
    void testFindAll() {
        ObjectifConsommation objectif1 = new ObjectifConsommation(500.0, "Monthly", LocalDate.now(), LocalDate.now().plusMonths(1), testUser);
        ObjectifConsommation objectif2 = new ObjectifConsommation(600.0, "Monthly", LocalDate.now().plusMonths(1), LocalDate.now().plusMonths(2), testUser);
        objectifDao.create(objectif1);
        objectifDao.create(objectif2);

        List<ObjectifConsommation> objectifs = objectifDao.findAll();
        assertNotNull(objectifs);
        assertEquals(2, objectifs.size());
    }

    @Test
    void testUpdate() {
        ObjectifConsommation objectif = new ObjectifConsommation(500.0, "Monthly", LocalDate.now(), LocalDate.now().plusMonths(1), testUser);
        objectifDao.create(objectif);

        objectif.setSeuilMaximum(550.0);
        assertTrue(objectifDao.update(objectif));

        ObjectifConsommation updatedObjectif = objectifDao.findById(objectif.getIdObjectif());
        assertEquals(550.0, updatedObjectif.getSeuilMaximum());
    }

    @Test
    void testDelete() {
        ObjectifConsommation objectif = new ObjectifConsommation(500.0, "Monthly", LocalDate.now(), LocalDate.now().plusMonths(1), testUser);
        objectifDao.create(objectif);

        assertTrue(objectifDao.delete(objectif));
        ObjectifConsommation deletedObjectif = objectifDao.findById(objectif.getIdObjectif());
        assertNull(deletedObjectif);
    }
}
