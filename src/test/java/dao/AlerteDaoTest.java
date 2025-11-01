package dao;

import model.Alerte;
import model.TypeAlerte;
import model.TypeUtilisateur;
import model.Utilisateur;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class AlerteDaoTest {

    private AlerteDao alerteDao;
    private UtilisateurDao utilisateurDao;
    private Utilisateur testUser;

    @BeforeEach
    void setUp() {
        alerteDao = new AlerteDao();
        utilisateurDao = new UtilisateurDao();
        testUser = new Utilisateur("Test User", "test@example.com", "password", TypeUtilisateur.CITOYEN);
        utilisateurDao.create(testUser);
    }

    @AfterEach
    void tearDown() {
        List<Alerte> alertes = alerteDao.findAll();
        for (Alerte alerte : alertes) {
            alerteDao.delete(alerte);
        }
        utilisateurDao.delete(testUser);
    }

    @Test
    void testCreateAndFindById() {
        Alerte alerte = new Alerte(TypeAlerte.SEUIL_DEPASSE, "Test Alerte", "High", testUser);
        assertTrue(alerteDao.create(alerte));

        Alerte foundAlerte = alerteDao.findById(alerte.getIdAlerte());
        assertNotNull(foundAlerte);
        assertEquals("Test Alerte", foundAlerte.getMessage());
    }

    @Test
    void testFindAll() {
        Alerte alerte1 = new Alerte(TypeAlerte.SEUIL_DEPASSE, "Test Alerte 1", "High", testUser);
        Alerte alerte2 = new Alerte(TypeAlerte.FUITE_DETECTEE, "Test Alerte 2", "Medium", testUser);
        alerteDao.create(alerte1);
        alerteDao.create(alerte2);

        List<Alerte> alertes = alerteDao.findAll();
        assertNotNull(alertes);
        assertEquals(2, alertes.size());
    }

    @Test
    void testUpdate() {
        Alerte alerte = new Alerte(TypeAlerte.SEUIL_DEPASSE, "Test Alerte", "High", testUser);
        alerteDao.create(alerte);

        alerte.setMessage("Updated Test Alerte");
        assertTrue(alerteDao.update(alerte));

        Alerte updatedAlerte = alerteDao.findById(alerte.getIdAlerte());
        assertEquals("Updated Test Alerte", updatedAlerte.getMessage());
    }

    @Test
    void testDelete() {
        Alerte alerte = new Alerte(TypeAlerte.SEUIL_DEPASSE, "Test Alerte", "High", testUser);
        alerteDao.create(alerte);

        assertTrue(alerteDao.delete(alerte));
        Alerte deletedAlerte = alerteDao.findById(alerte.getIdAlerte());
        assertNull(deletedAlerte);
    }
}
