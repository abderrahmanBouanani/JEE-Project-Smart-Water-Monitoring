package dao;

import model.Statistique;
import model.TypeUtilisateur;
import model.Utilisateur;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class StatistiqueDaoTest {

    private StatistiqueDao statistiqueDao;
    private UtilisateurDao utilisateurDao;
    private Utilisateur testUser;

    @BeforeEach
    void setUp() {
        statistiqueDao = new StatistiqueDao();
        utilisateurDao = new UtilisateurDao();
        testUser = new Utilisateur("Test User", "test@example.com", "password", TypeUtilisateur.CITOYEN);
        utilisateurDao.create(testUser);
    }

    @AfterEach
    void tearDown() {
        List<Statistique> statistiques = statistiqueDao.findAll();
        for (Statistique statistique : statistiques) {
            statistiqueDao.delete(statistique);
        }
        utilisateurDao.delete(testUser);
    }

    @Test
    void testCreateAndFindById() {
        Statistique statistique = new Statistique("Consumption", 150.0, "Daily", testUser);
        assertTrue(statistiqueDao.create(statistique));

        Statistique foundStatistique = statistiqueDao.findById(statistique.getIdStatistique());
        assertNotNull(foundStatistique);
        assertEquals(150.0, foundStatistique.getValeur());
    }

    @Test
    void testFindAll() {
        Statistique statistique1 = new Statistique("Consumption", 150.0, "Daily", testUser);
        Statistique statistique2 = new Statistique("Cost", 75.0, "Daily", testUser);
        statistiqueDao.create(statistique1);
        statistiqueDao.create(statistique2);

        List<Statistique> statistiques = statistiqueDao.findAll();
        assertNotNull(statistiques);
        assertEquals(2, statistiques.size());
    }

    @Test
    void testUpdate() {
        Statistique statistique = new Statistique("Consumption", 150.0, "Daily", testUser);
        statistiqueDao.create(statistique);

        statistique.setValeur(160.0);
        assertTrue(statistiqueDao.update(statistique));

        Statistique updatedStatistique = statistiqueDao.findById(statistique.getIdStatistique());
        assertEquals(160.0, updatedStatistique.getValeur());
    }

    @Test
    void testDelete() {
        Statistique statistique = new Statistique("Consumption", 150.0, "Daily", testUser);
        statistiqueDao.create(statistique);

        assertTrue(statistiqueDao.delete(statistique));
        Statistique deletedStatistique = statistiqueDao.findById(statistique.getIdStatistique());
        assertNull(deletedStatistique);
    }
}
