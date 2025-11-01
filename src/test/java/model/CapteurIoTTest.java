package model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDate;

class CapteurIoTTest {

    @Test
    void testCapteurIoTCreation() {
        Utilisateur utilisateur = new Utilisateur("Jane Doe", "jane.doe@example.com", "password", TypeUtilisateur.CITOYEN);
        CapteurIoT capteur = new CapteurIoT("REF123", TypeCapteur.RESIDENTIEL, "Living Room", utilisateur);
        capteur.setSeuilAlerte(50.0);

        assertNotNull(capteur);
        assertEquals("REF123", capteur.getReference());
        assertEquals(TypeCapteur.RESIDENTIEL, capteur.getType());
        assertEquals("Living Room", capteur.getEmplacement());
        assertTrue(capteur.isEtat());
        assertNotNull(capteur.getDateInstallation());
        assertEquals(50.0, capteur.getSeuilAlerte());
        assertEquals(utilisateur, capteur.getUtilisateur());
    }
}
