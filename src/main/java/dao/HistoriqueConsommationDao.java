package dao;

import model.HistoriqueConsommation;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import util.HibernateUtil;
import java.util.List;

public class HistoriqueConsommationDao extends AbstractDao<HistoriqueConsommation> {
    public HistoriqueConsommationDao() {
        super(HistoriqueConsommation.class);
    }

    @Override
    public List<HistoriqueConsommation> findByUserId(Long userId) {
        Session session = null;
        Transaction tx = null;
        List<HistoriqueConsommation> list = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            // ✅ CORRECTION: Utiliser JOIN FETCH pour charger l'utilisateur en une seule requête
            String query = "SELECT h FROM HistoriqueConsommation h " +
                    "JOIN FETCH h.utilisateur u " +
                    "WHERE u.idUtilisateur = :userId " +
                    "ORDER BY h.date DESC";

            list = session.createQuery(query, HistoriqueConsommation.class)
                    .setParameter("userId", userId)
                    .list();

            tx.commit();
            System.out.println("✅ HistoriqueDao - Données récupérées pour userId " + userId + ": " + list.size() + " enregistrements");

        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            System.out.println("❌ Erreur HistoriqueDao.findByUserId: " + e.getMessage());
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }

    // ✅ CORRECTION: Surcharger aussi findAll() pour utiliser JOIN FETCH
    @Override
    public List<HistoriqueConsommation> findAll() {
        Session session = null;
        Transaction tx = null;
        List<HistoriqueConsommation> list = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();

            // Utiliser JOIN FETCH pour éviter LazyInitializationException
            list = session.createQuery(
                            "SELECT h FROM HistoriqueConsommation h JOIN FETCH h.utilisateur ORDER BY h.date DESC",
                            HistoriqueConsommation.class)
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