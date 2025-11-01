package model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

class DonneeCapteurTest {

    @Test
    void testDonneeCapteurCreation() {
        Utilisateur utilisateur = new Utilisateur("Jane Doe", "jane.doe@example.com", "password", TypeUtilisateur.CITOYEN);
        CapteurIoT capteur = new CapteurIoT("REF123", TypeCapteur.RESIDENTIEL, "Living Room", utilisateur);
        DonneeCapteur donnee = new DonneeCapteur(12.5, "L", capteur);

        assertNotNull(donnee);
        assertNotNull(donnee.getHorodatage());
        assertEquals(12.5, donnee.getValeurConsommation());
        assertEquals("L", donnee.getUnite());
        assertEquals(capteur, donnee.getCapteur());
    }
}
