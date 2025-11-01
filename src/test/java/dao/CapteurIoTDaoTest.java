package dao;

import model.CapteurIoT;
import model.TypeCapteur;
import model.TypeUtilisateur;
import model.Utilisateur;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class CapteurIoTDaoTest {

    private CapteurIoTDao capteurIoTDao;
    private UtilisateurDao utilisateurDao;
    private Utilisateur testUser;

    @BeforeEach
    void setUp() {
        capteurIoTDao = new CapteurIoTDao();
        utilisateurDao = new UtilisateurDao();
        testUser = new Utilisateur("Test User", "test@example.com", "password", TypeUtilisateur.CITOYEN);
        utilisateurDao.create(testUser);
    }

    @AfterEach
    void tearDown() {
        List<CapteurIoT> capteurs = capteurIoTDao.findAll();
        for (CapteurIoT capteur : capteurs) {
            capteurIoTDao.delete(capteur);
        }
        utilisateurDao.delete(testUser);
    }

    @Test
    void testCreateAndFindById() {
        CapteurIoT capteur = new CapteurIoT("REF-001", TypeCapteur.RESIDENTIEL, "Kitchen", testUser);
        assertTrue(capteurIoTDao.create(capteur));

        CapteurIoT foundCapteur = capteurIoTDao.findById(capteur.getIdCapteur());
        assertNotNull(foundCapteur);
        assertEquals("REF-001", foundCapteur.getReference());
    }

    @Test
    void testFindAll() {
        CapteurIoT capteur1 = new CapteurIoT("REF-001", TypeCapteur.RESIDENTIEL, "Kitchen", testUser);
        CapteurIoT capteur2 = new CapteurIoT("REF-002", TypeCapteur.INDUSTRIEL, "Bathroom", testUser);
        capteurIoTDao.create(capteur1);
        capteurIoTDao.create(capteur2);

        List<CapteurIoT> capteurs = capteurIoTDao.findAll();
        assertNotNull(capteurs);
        assertEquals(2, capteurs.size());
    }

    @Test
    void testUpdate() {
        CapteurIoT capteur = new CapteurIoT("REF-001", TypeCapteur.RESIDENTIEL, "Kitchen", testUser);
        capteurIoTDao.create(capteur);

        capteur.setEmplacement("Garage");
        assertTrue(capteurIoTDao.update(capteur));

        CapteurIoT updatedCapteur = capteurIoTDao.findById(capteur.getIdCapteur());
        assertEquals("Garage", updatedCapteur.getEmplacement());
    }

    @Test
    void testDelete() {
        CapteurIoT capteur = new CapteurIoT("REF-001", TypeCapteur.RESIDENTIEL, "Kitchen", testUser);
        capteurIoTDao.create(capteur);

        assertTrue(capteurIoTDao.delete(capteur));
        CapteurIoT deletedCapteur = capteurIoTDao.findById(capteur.getIdCapteur());
        assertNull(deletedCapteur);
    }
}
