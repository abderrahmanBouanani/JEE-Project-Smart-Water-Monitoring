package model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDate;

class HistoriqueConsommationTest {

    @Test
    void testHistoriqueConsommationCreation() {
        Utilisateur utilisateur = new Utilisateur("Jane Doe", "jane.doe@example.com", "password", TypeUtilisateur.CITOYEN);
        HistoriqueConsommation historique = new HistoriqueConsommation(LocalDate.now(), 150.0, 25.0, 5.0, utilisateur);

        assertNotNull(historique);
        assertEquals(LocalDate.now(), historique.getDate());
        assertEquals(150.0, historique.getVolumeTotal());
        assertEquals(25.0, historique.getCoutEstime());
        assertEquals(5.0, historique.getConsommationMoyenne());
        assertEquals(utilisateur, historique.getUtilisateur());
    }
}
