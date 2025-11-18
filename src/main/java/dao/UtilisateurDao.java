package dao;

import model.Utilisateur;
import model.TypeUtilisateur;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.query.Query;
import util.HibernateUtil;

public class UtilisateurDao extends AbstractDao<Utilisateur> {
    public UtilisateurDao() {
        super(Utilisateur.class);
    }

    @Override
    public Utilisateur findByEmail(String email) {
        Session session = null;
        Transaction tx = null;
        Utilisateur utilisateur = null;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();
            Query<Utilisateur> query = session.createQuery("FROM Utilisateur WHERE email = :email", Utilisateur.class);
            query.setParameter("email", email);
            utilisateur = query.uniqueResult(); // uniqueResult() car l'email est unique
            tx.commit();
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return utilisateur;
    }

    public long countByType(TypeUtilisateur type) {
        Session session = null;
        Transaction tx = null;
        long count = 0;
        try {
            session = HibernateUtil.getSessionFactory().openSession();
            tx = session.beginTransaction();
            count = (Long) session.createQuery("SELECT COUNT(u) FROM Utilisateur u WHERE u.type = :type")
                    .setParameter("type", type)
                    .uniqueResult();
            tx.commit();
        } catch (HibernateException e) {
            if (tx != null) tx.rollback();
            e.printStackTrace();
        } finally {
            if (session != null) session.close();
        }
        return count;
    }
}
