package dao;

import model.Alerte;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import util.HibernateUtil;
import java.util.List;

public class AlerteDao extends AbstractDao<Alerte> {
    public AlerteDao() {
        super(Alerte.class);
    }

    // Méthode pour récupérer les alertes d'un utilisateur spécifique
    public List<Alerte> findByUserId(Long userId) {
        Session session = null;
        Transaction tx = null;
        List<Alerte> list = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            // ✅ Utiliser JOIN FETCH pour charger toutes les relations nécessaires
            String query = "SELECT DISTINCT a FROM Alerte a " +
                    "JOIN FETCH a.utilisateur u " +
                    "LEFT JOIN FETCH a.donneeCapteur dc " +
                    "LEFT JOIN FETCH dc.capteur " +
                    "WHERE u.idUtilisateur = :userId " +
                    "ORDER BY a.dateCreation DESC";

            list = session.createQuery(query, Alerte.class)
                    .setParameter("userId", userId)
                    .list();

            tx.commit();
            System.out.println("✅ AlerteDao - Alertes récupérées pour userId " + userId + ": " + list.size() + " alertes");

        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("❌ Erreur AlerteDao.findByUserId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

    // Méthode pour les alertes non lues
    public List<Alerte> findUnreadByUserId(Long userId) {
        Session session = null;
        Transaction tx = null;
        List<Alerte> list = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            String query = "SELECT DISTINCT a FROM Alerte a " +
                    "JOIN FETCH a.utilisateur u " +
                    "LEFT JOIN FETCH a.donneeCapteur dc " +
                    "LEFT JOIN FETCH dc.capteur " +
                    "WHERE u.idUtilisateur = :userId AND a.estLue = false " +
                    "ORDER BY a.dateCreation DESC";

            list = session.createQuery(query, Alerte.class)
                    .setParameter("userId", userId)
                    .list();

            tx.commit();
            System.out.println("✅ AlerteDao - Alertes non lues pour userId " + userId + ": " + list.size() + " alertes");

        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("❌ Erreur AlerteDao.findUnreadByUserId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

    // Surcharger findAll() avec JOIN FETCH
    @Override
    public List<Alerte> findAll() {
        Session session = null;
        Transaction tx = null;
        List<Alerte> list = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            // Charger toutes les relations nécessaires avec JOIN FETCH pour éviter LazyInitializationException
            list = session.createQuery(
                            "SELECT DISTINCT a FROM Alerte a " +
                            "LEFT JOIN FETCH a.utilisateur " +
                            "LEFT JOIN FETCH a.donneeCapteur dc " +
                            "LEFT JOIN FETCH dc.capteur " +
                            "ORDER BY a.dateCreation DESC",
                            Alerte.class)
                    .list();

            tx.commit();
            System.out.println("✅ AlerteDao - Toutes les alertes récupérées: " + (list != null ? list.size() : 0) + " alertes");
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.err.println("❌ Erreur AlerteDao.findAll: " + e.getMessage());
            e.printStackTrace();
            return new java.util.ArrayList<>(); // Retourner une liste vide plutôt que null
        } finally {
            if (session != null) session.close();
        }
        return list != null ? list : new java.util.ArrayList<>();
    }
}