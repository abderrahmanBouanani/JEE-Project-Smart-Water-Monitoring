package dao;

import model.CapteurIoT;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import util.HibernateUtil;
import java.util.List;

public class CapteurIoTDao extends AbstractDao<CapteurIoT> {
    public CapteurIoTDao() {
        super(CapteurIoT.class);
    }

    // Méthode existante avec JOIN FETCH
    @Override
    public List<CapteurIoT> findAll() {
        Session session = null;
        Transaction tx = null;
        List<CapteurIoT> list = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();
            // Utilisation de JOIN FETCH pour charger l'utilisateur associé
            list = session.createQuery("FROM CapteurIoT c JOIN FETCH c.utilisateur", CapteurIoT.class).list();
            tx.commit();
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

    // ✅ NOUVELLE MÉTHODE - Récupère les capteurs d'un utilisateur spécifique
    public List<CapteurIoT> findByUserId(Long userId) {
        Session session = null;
        Transaction tx = null;
        List<CapteurIoT> list = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            String query = "SELECT c FROM CapteurIoT c " +
                    "JOIN FETCH c.utilisateur u " +
                    "WHERE u.idUtilisateur = :userId " +
                    "ORDER BY c.dateInstallation DESC";

            list = session.createQuery(query, CapteurIoT.class)
                    .setParameter("userId", userId)
                    .list();

            tx.commit();
            System.out.println("✅ CapteurIoTDao - Capteurs récupérés pour userId " + userId + ": " + list.size() + " capteurs");

        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("❌ Erreur CapteurIoTDao.findByUserId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

    // ✅ MÉTHODE - Compter les capteurs actifs d'un utilisateur
    public long countActiveByUserId(Long userId) {
        Session session = null;
        Transaction tx = null;
        Long count = 0L;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            String query = "SELECT COUNT(c) FROM CapteurIoT c " +
                    "WHERE c.utilisateur.idUtilisateur = :userId AND c.etat = true";

            count = session.createQuery(query, Long.class)
                    .setParameter("userId", userId)
                    .uniqueResult();

            tx.commit();

        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return count != null ? count : 0L;
    }
}