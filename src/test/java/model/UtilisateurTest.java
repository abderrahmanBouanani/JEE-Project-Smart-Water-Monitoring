package model;

import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.*;

import java.time.LocalDateTime;

class UtilisateurTest {

    @Test
    void testUtilisateurCreation() {
        Utilisateur utilisateur = new Utilisateur("John Doe", "john.doe@example.com", "password", TypeUtilisateur.CITOYEN);
        utilisateur.setAdresse("123 Main St");

        assertNotNull(utilisateur);
        assertEquals("John Doe", utilisateur.getNom());
        assertEquals("john.doe@example.com", utilisateur.getEmail());
        assertEquals("password", utilisateur.getMotDePasse());
        assertEquals(TypeUtilisateur.CITOYEN, utilisateur.getType());
        assertEquals("123 Main St", utilisateur.getAdresse());
        assertNotNull(utilisateur.getDateInscription());
    }
}
