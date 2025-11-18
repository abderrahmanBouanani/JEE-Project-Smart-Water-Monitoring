package dao;

import model.DonneeCapteur;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import util.HibernateUtil;

import java.util.List;

public class DonneeCapteurDao extends AbstractDao<DonneeCapteur> {
    public DonneeCapteurDao() {
        super(DonneeCapteur.class);
    }

    public List<DonneeCapteur> findRecentByUserId(Long userId) {
        Session session = null;
        Transaction tx = null;
        List<DonneeCapteur> list = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            // Récupère les dernières données de chaque capteur de l'utilisateur
            String query = "SELECT d FROM DonneeCapteur d " +
                    "JOIN FETCH d.capteur c " +
                    "JOIN FETCH c.utilisateur u " +
                    "WHERE u.idUtilisateur = :userId " +
                    "AND d.horodatage = (SELECT MAX(d2.horodatage) FROM DonneeCapteur d2 WHERE d2.capteur.idCapteur = c.idCapteur) " +
                    "ORDER BY d.horodatage DESC";

            list = session.createQuery(query, DonneeCapteur.class)
                    .setParameter("userId", userId)
                    .list();

            tx.commit();
            System.out.println("✅ DonneeCapteurDao - Dernières données récupérées pour userId " + userId + ": " + list.size() + " enregistrements");

        } catch (HibernateException e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.out.println("❌ Erreur DonneeCapteurDao.findRecentByUserId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
        return list;
    }

    /**
     * Récupère la consommation quotidienne des 7 derniers jours pour un utilisateur
     * @param userId ID de l'utilisateur
     * @return Liste de 7 valeurs (de J-6 à aujourd'hui)
     */
    public List<Double> getDailyConsumptionLast7Days(Long userId) {
        Session session = null;
        Transaction tx = null;
        List<Double> result = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            String query = "SELECT COALESCE(SUM(d.valeurConsommation), 0) " +
                    "FROM DonneeCapteur d " +
                    "JOIN d.capteur c " +
                    "WHERE c.utilisateur.idUtilisateur = :userId " +
                    "AND FUNCTION('DATE', d.horodatage) = FUNCTION('DATE', CURRENT_DATE - :daysAgo) " +
                    "GROUP BY FUNCTION('DATE', d.horodatage)";

            result = new java.util.ArrayList<>();
            for (int i = 6; i >= 0; i--) {
                List<Double> dayResult = session.createQuery(query, Double.class)
                        .setParameter("userId", userId)
                        .setParameter("daysAgo", i)
                        .list();
                result.add(dayResult.isEmpty() ? 0.0 : dayResult.get(0));
            }

            tx.commit();
            System.out.println("✅ Consommation quotidienne (7 jours): " + result);

        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.out.println("❌ Erreur getDailyConsumptionLast7Days: " + e.getMessage());
            e.printStackTrace();
            // Retourner des valeurs par défaut en cas d'erreur
            result = java.util.Arrays.asList(0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
        return result;
    }

    /**
     * Récupère la consommation mensuelle des 6 derniers mois pour un utilisateur
     * @param userId ID de l'utilisateur
     * @return Liste de 6 valeurs (de M-5 à ce mois)
     */
    public List<Double> getMonthlyConsumptionLast6Months(Long userId) {
        Session session = null;
        Transaction tx = null;
        List<Double> result = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            String query = "SELECT COALESCE(SUM(d.valeurConsommation), 0) " +
                    "FROM DonneeCapteur d " +
                    "JOIN d.capteur c " +
                    "WHERE c.utilisateur.idUtilisateur = :userId " +
                    "AND FUNCTION('YEAR', d.horodatage) = FUNCTION('YEAR', CURRENT_DATE - :monthsAgo * 30) " +
                    "AND FUNCTION('MONTH', d.horodatage) = FUNCTION('MONTH', CURRENT_DATE - :monthsAgo * 30)";

            result = new java.util.ArrayList<>();
            for (int i = 5; i >= 0; i--) {
                List<Double> monthResult = session.createQuery(query, Double.class)
                        .setParameter("userId", userId)
                        .setParameter("monthsAgo", i)
                        .list();
                result.add(monthResult.isEmpty() ? 0.0 : monthResult.get(0));
            }

            tx.commit();
            System.out.println("✅ Consommation mensuelle (6 mois): " + result);

        } catch (Exception e) {
            if (tx != null && tx.isActive()) {
                tx.rollback();
            }
            System.out.println("❌ Erreur getMonthlyConsumptionLast6Months: " + e.getMessage());
            e.printStackTrace();
            // Retourner des valeurs par défaut en cas d'erreur
            result = java.util.Arrays.asList(0.0, 0.0, 0.0, 0.0, 0.0, 0.0);
        } finally {
            if (session != null && session.isOpen()) {
                session.close();
            }
        }
        return result;
    }

    public double getTotalConsumption() {
        Session session = null;
        Transaction tx = null;
        double total = 0.0;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();
            Double result = (Double) session.createQuery("SELECT COALESCE(SUM(d.valeurConsommation), 0) FROM DonneeCapteur d")
                    .uniqueResult();
            total = result != null ? result : 0.0;
            tx.commit();
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return total;
    }

    public double getAverageConsumption() {
        Session session = null;
        Transaction tx = null;
        double avg = 0.0;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();
            Double result = (Double) session.createQuery("SELECT COALESCE(AVG(d.valeurConsommation), 0) FROM DonneeCapteur d")
                    .uniqueResult();
            avg = result != null ? result : 0.0;
            tx.commit();
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return avg;
    }
}