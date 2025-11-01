package model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDate;

class ObjectifConsommationTest {

    @Test
    void testObjectifConsommationCreation() {
        Utilisateur utilisateur = new Utilisateur("Jane Doe", "jane.doe@example.com", "password", TypeUtilisateur.CITOYEN);
        LocalDate startDate = LocalDate.now();
        LocalDate endDate = startDate.plusMonths(1);
        ObjectifConsommation objectif = new ObjectifConsommation(1000.0, "Monthly", startDate, endDate, utilisateur);

        assertNotNull(objectif);
        assertEquals(1000.0, objectif.getSeuilMaximum());
        assertEquals("Monthly", objectif.getPeriode());
        assertEquals(startDate, objectif.getDateDebut());
        assertEquals(endDate, objectif.getDateFin());
        assertFalse(objectif.isEstAtteint());
        assertEquals(utilisateur, objectif.getUtilisateur());
    }
}
