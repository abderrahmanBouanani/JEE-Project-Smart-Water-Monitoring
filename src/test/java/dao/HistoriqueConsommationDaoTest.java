package dao;

import model.HistoriqueConsommation;
import model.TypeUtilisateur;
import model.Utilisateur;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class HistoriqueConsommationDaoTest {

    private HistoriqueConsommationDao historiqueDao;
    private UtilisateurDao utilisateurDao;
    private Utilisateur testUser;

    @BeforeEach
    void setUp() {
        historiqueDao = new HistoriqueConsommationDao();
        utilisateurDao = new UtilisateurDao();
        testUser = new Utilisateur("Test User", "test@example.com", "password", TypeUtilisateur.CITOYEN);
        utilisateurDao.create(testUser);
    }

    @AfterEach
    void tearDown() {
        List<HistoriqueConsommation> historiques = historiqueDao.findAll();
        for (HistoriqueConsommation historique : historiques) {
            historiqueDao.delete(historique);
        }
        utilisateurDao.delete(testUser);
    }

    @Test
    void testCreateAndFindById() {
        HistoriqueConsommation historique = new HistoriqueConsommation(LocalDate.now(), 100.0, 50.0, 5.0, testUser);
        assertTrue(historiqueDao.create(historique));

        HistoriqueConsommation foundHistorique = historiqueDao.findById(historique.getIdHistorique());
        assertNotNull(foundHistorique);
        assertEquals(100.0, foundHistorique.getVolumeTotal());
    }

    @Test
    void testFindAll() {
        HistoriqueConsommation historique1 = new HistoriqueConsommation(LocalDate.now(), 100.0, 50.0, 5.0, testUser);
        HistoriqueConsommation historique2 = new HistoriqueConsommation(LocalDate.now().minusDays(1), 120.0, 60.0, 6.0, testUser);
        historiqueDao.create(historique1);
        historiqueDao.create(historique2);

        List<HistoriqueConsommation> historiques = historiqueDao.findAll();
        assertNotNull(historiques);
        assertEquals(2, historiques.size());
    }

    @Test
    void testUpdate() {
        HistoriqueConsommation historique = new HistoriqueConsommation(LocalDate.now(), 100.0, 50.0, 5.0, testUser);
        historiqueDao.create(historique);

        historique.setVolumeTotal(110.0);
        assertTrue(historiqueDao.update(historique));

        HistoriqueConsommation updatedHistorique = historiqueDao.findById(historique.getIdHistorique());
        assertEquals(110.0, updatedHistorique.getVolumeTotal());
    }

    @Test
    void testDelete() {
        HistoriqueConsommation historique = new HistoriqueConsommation(LocalDate.now(), 100.0, 50.0, 5.0, testUser);
        historiqueDao.create(historique);

        assertTrue(historiqueDao.delete(historique));
        HistoriqueConsommation deletedHistorique = historiqueDao.findById(historique.getIdHistorique());
        assertNull(deletedHistorique);
    }
}
