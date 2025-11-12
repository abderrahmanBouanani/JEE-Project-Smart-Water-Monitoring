package util;

import model.CapteurIoT;
import model.TypeCapteur;
import org.hibernate.Session;
import org.hibernate.Transaction;
import jakarta.persistence.Query;

/**
 * Utilitaire pour corriger les données enum invalides dans la base de données
 */
public class EnumDataMigrator {

    /**
     * Corrige les valeurs enum invalides pour les capteurs
     */
    public static void fixInvalidCapteurTypes() {
        Session session = null;
        Transaction tx = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            // 1. Mettre à jour les valeurs NULL ou vides
            String updateNullQuery = "UPDATE capteurs SET `type` = 'DEBIT_EAU' WHERE `type` IS NULL OR `type` = ''";
            Query query1 = session.createNativeQuery(updateNullQuery);
            int updatedNullRows = query1.executeUpdate();
            if (updatedNullRows > 0) {
                System.out.println("✅ " + updatedNullRows + " capteur(s) avec type NULL corrigé(s)");
            }

            // 2. Mettre à jour les valeurs invalides
            String updateInvalidQuery = "UPDATE capteurs SET `type` = 'DEBIT_EAU' WHERE `type` NOT IN " +
                    "('RESIDENTIEL', 'INDUSTRIEL', 'AGRICOLE', 'DEBIT_EAU', 'QUALITE_EAU')";
            Query query2 = session.createNativeQuery(updateInvalidQuery);
            int updatedInvalidRows = query2.executeUpdate();
            if (updatedInvalidRows > 0) {
                System.out.println("✅ " + updatedInvalidRows + " capteur(s) avec type invalide corrigé(s)");
            }

            tx.commit();
            System.out.println("✅ Correction des types enum terminée avec succès");

        } catch (Exception e) {
            if (tx != null) tx.rollback();
            System.out.println("⚠️ Erreur lors de la correction des types enum: " + e.getMessage());
            // Ne pas lever l'exception pour ne pas bloquer le démarrage de l'application
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
    }

    /**
     * Affiche les statistiques des types de capteurs
     */
    public static void printCapteurTypeStatistics() {
        Session session = null;
        Transaction tx = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            // Récupérer les statistiques
            String query = "SELECT c.type, COUNT(c) FROM CapteurIoT c GROUP BY c.type";
            java.util.List<Object[]> stats = session.createQuery(query).list();

            if (!stats.isEmpty()) {
                System.out.println("📊 Statistiques des types de capteurs:");
                for (Object[] stat : stats) {
                    System.out.println("   - " + stat[0] + ": " + stat[1] + " capteur(s)");
                }
            }

            tx.commit();
        } catch (Exception e) {
            if (tx != null) tx.rollback();
            // Silencieusement ignorer les erreurs pour ne pas bloquer
            System.out.println("⚠️ Impossible de récupérer les statistiques des capteurs");
        } finally {
            if (session != null) session.close();
        }
    }
}

