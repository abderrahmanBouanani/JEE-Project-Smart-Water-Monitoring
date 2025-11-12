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
}