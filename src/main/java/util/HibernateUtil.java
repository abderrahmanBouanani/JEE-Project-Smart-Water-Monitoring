package util;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;

public class HibernateUtil {

    private static final SessionFactory sessionFactory = buildSessionFactory();

    private static SessionFactory buildSessionFactory() {
        try {
            // Create the SessionFactory from hibernate.cfg.xml
            System.out.println("🔄 Initializing Hibernate SessionFactory...");
            SessionFactory sf = new Configuration().configure().buildSessionFactory();
            System.out.println("✅ Hibernate SessionFactory initialized successfully");
            return sf;
        } catch (Throwable ex) {
            // Log the exception with full stack trace
            System.err.println("❌ Initial SessionFactory creation failed!");
            System.err.println("Error: " + ex.getMessage());
            ex.printStackTrace();

            // Print root cause if available
            if (ex.getCause() != null) {
                System.err.println("Root cause: " + ex.getCause().getMessage());
                ex.getCause().printStackTrace();
            }

            throw new ExceptionInInitializerError(ex);
        }
    }

    public static SessionFactory getSessionFactory() {
        return sessionFactory;
    }

    public static void shutdown() {
        // Close caches and connection pools
        SessionFactory sf = getSessionFactory();
        if (sf != null && !sf.isClosed()) {
            sf.close();
        }
    }

}