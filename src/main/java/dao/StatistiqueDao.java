package dao;

import model.Statistique;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import util.HibernateUtil;
import java.util.List;

public class StatistiqueDao extends AbstractDao<Statistique> {
    public StatistiqueDao() {
        super(Statistique.class);
    }

    // ✅ NOUVELLE MÉTHODE - Récupère les statistiques d'un utilisateur spécifique
    public List<Statistique> findByUserId(Long userId) {
        Session session = null;
        Transaction tx = null;
        List<Statistique> list = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            String query = "SELECT s FROM Statistique s " +
                    "JOIN FETCH s.utilisateur u " +
                    "WHERE u.idUtilisateur = :userId " +
                    "ORDER BY s.dateGeneration DESC";

            list = session.createQuery(query, Statistique.class)
                    .setParameter("userId", userId)
                    .list();

            tx.commit();
            System.out.println("✅ StatistiqueDao - Statistiques récupérées pour userId " + userId + ": " + list.size() + " enregistrements");

        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("❌ Erreur StatistiqueDao.findByUserId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

    // ✅ MÉTHODE - Récupère les statistiques par type et utilisateur
    public List<Statistique> findByTypeAndUserId(String type, Long userId) {
        Session session = null;
        Transaction tx = null;
        List<Statistique> list = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            String query = "SELECT s FROM Statistique s " +
                    "WHERE s.utilisateur.idUtilisateur = :userId AND s.type = :type " +
                    "ORDER BY s.dateGeneration DESC";

            list = session.createQuery(query, Statistique.class)
                    .setParameter("userId", userId)
                    .setParameter("type", type)
                    .list();

            tx.commit();

        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

    // Surcharger findAll() avec JOIN FETCH
    @Override
    public List<Statistique> findAll() {
        Session session = null;
        Transaction tx = null;
        List<Statistique> list = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            list = session.createQuery(
                            "SELECT s FROM Statistique s JOIN FETCH s.utilisateur ORDER BY s.dateGeneration DESC",
                            Statistique.class)
                    .list();

            tx.commit();
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }
}