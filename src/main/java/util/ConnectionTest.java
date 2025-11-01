package util;

public class ConnectionTest {

    public static void main(String[] args) {
        try {
            HibernateUtil.getSessionFactory();
            System.out.println("Connection to database established successfully.");
            HibernateUtil.shutdown();
        } catch (Throwable ex) {
            System.err.println("Connection to database failed." + ex);
        }
    }
}