package model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class AlerteTest {

    @Test
    void testAlerteCreation() {
        Utilisateur utilisateur = new Utilisateur("Jane Doe", "jane.doe@example.com", "password", TypeUtilisateur.CITOYEN);
        Alerte alerte = new Alerte(TypeAlerte.SEUIL_DEPASSE, "High consumption detected", "High", utilisateur);

        assertNotNull(alerte);
        assertEquals(TypeAlerte.SEUIL_DEPASSE, alerte.getType());
        assertNotNull(alerte.getDateCreation());
        assertFalse(alerte.isEstLue());
        assertEquals("High consumption detected", alerte.getMessage());
        assertEquals("High", alerte.getNiveauUrgence());
        assertEquals(utilisateur, alerte.getUtilisateur());
    }
}
