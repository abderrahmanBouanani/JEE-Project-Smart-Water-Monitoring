package model;

import org.junit.Test;

import static junit.framework.Assert.assertNotNull;
import static org.junit.jupiter.api.Assertions.*;

class StatistiqueTest {

    @Test
    void testStatistiqueCreation() {
        Utilisateur utilisateur = new Utilisateur("Jane Doe", "jane.doe@example.com", "password", TypeUtilisateur.CITOYEN);
        Statistique statistique = new Statistique("Average Consumption", 120.0, "Monthly", utilisateur);

        assertNotNull(statistique);
        assertEquals("Average Consumption", statistique.getType());
        assertEquals(120.0, statistique.getValeur());
        assertEquals("Monthly", statistique.getPeriode());
        assertNotNull(statistique.getDateGeneration());
        assertEquals(utilisateur, statistique.getUtilisateur());
    }
}
