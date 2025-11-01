package dao;

import model.*;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class DonneeCapteurDaoTest {

    private DonneeCapteurDao donneeCapteurDao;
    private CapteurIoTDao capteurIoTDao;
    private UtilisateurDao utilisateurDao;
    private Utilisateur testUser;
    private CapteurIoT testCapteur;

    @BeforeEach
    void setUp() {
        donneeCapteurDao = new DonneeCapteurDao();
        capteurIoTDao = new CapteurIoTDao();
        utilisateurDao = new UtilisateurDao();

        testUser = new Utilisateur("Test User", "test@example.com", "password", TypeUtilisateur.CITOYEN);
        utilisateurDao.create(testUser);

        testCapteur = new CapteurIoT("REF-001", TypeCapteur.RESIDENTIEL, "Kitchen", testUser);
        capteurIoTDao.create(testCapteur);
    }

    @AfterEach
    void tearDown() {
        List<DonneeCapteur> donnees = donneeCapteurDao.findAll();
        for (DonneeCapteur donnee : donnees) {
            donneeCapteurDao.delete(donnee);
        }
        capteurIoTDao.delete(testCapteur);
        utilisateurDao.delete(testUser);
    }

    @Test
    void testCreateAndFindById() {
        DonneeCapteur donnee = new DonneeCapteur(10.5, "L/min", testCapteur);
        assertTrue(donneeCapteurDao.create(donnee));

        DonneeCapteur foundDonnee = donneeCapteurDao.findById(donnee.getIdDonnee());
        assertNotNull(foundDonnee);
        assertEquals(10.5, foundDonnee.getValeurConsommation());
    }

    @Test
    void testFindAll() {
        DonneeCapteur donnee1 = new DonneeCapteur(10.5, "L/min", testCapteur);
        DonneeCapteur donnee2 = new DonneeCapteur(11.2, "L/min", testCapteur);
        donneeCapteurDao.create(donnee1);
        donneeCapteurDao.create(donnee2);

        List<DonneeCapteur> donnees = donneeCapteurDao.findAll();
        assertNotNull(donnees);
        assertEquals(2, donnees.size());
    }

    @Test
    void testUpdate() {
        DonneeCapteur donnee = new DonneeCapteur(10.5, "L/min", testCapteur);
        donneeCapteurDao.create(donnee);

        donnee.setValeurConsommation(12.0);
        assertTrue(donneeCapteurDao.update(donnee));

        DonneeCapteur updatedDonnee = donneeCapteurDao.findById(donnee.getIdDonnee());
        assertEquals(12.0, updatedDonnee.getValeurConsommation());
    }

    @Test
    void testDelete() {
        DonneeCapteur donnee = new DonneeCapteur(10.5, "L/min", testCapteur);
        donneeCapteurDao.create(donnee);

        assertTrue(donneeCapteurDao.delete(donnee));
        DonneeCapteur deletedDonnee = donneeCapteurDao.findById(donnee.getIdDonnee());
        assertNull(deletedDonnee);
    }
}
