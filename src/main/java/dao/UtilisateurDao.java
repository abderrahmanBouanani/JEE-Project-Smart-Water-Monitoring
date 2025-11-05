package dao;

import model.Utilisateur;
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
}
