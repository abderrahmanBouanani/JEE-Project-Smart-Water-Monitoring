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

    /**
     * Surcharge la méthode findAll pour utiliser un JOIN FETCH.
     * Cela permet de charger les utilisateurs associés en une seule requête
     * et d'éviter les LazyInitializationException dans la vue.
     */
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
            // Log l'erreur ou la gérer
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return list;
    }
}
