package util;

/**
 * Classe utilitaire pour gérer les conversions d'énumérés
 */
public class EnumUtil {

    /**
     * Convertit une chaîne de caractères en énumération de manière sécurisée
     * @param enumClass Classe de l'énumération
     * @param value Valeur à convertir (peut être null ou invalide)
     * @param defaultValue Valeur par défaut si la conversion échoue
     * @return Valeur énumérée ou valeur par défaut
     */
    public static <E extends Enum<E>> E parseEnum(Class<E> enumClass, String value, E defaultValue) {
        if (value == null || value.trim().isEmpty()) {
            return defaultValue;
        }

        try {
            return Enum.valueOf(enumClass, value.trim().toUpperCase());
        } catch (IllegalArgumentException | NullPointerException e) {
            System.out.println("⚠️ Valeur invalide pour " + enumClass.getSimpleName() + ": '" + value +
                             "'. Utilisation de la valeur par défaut: " + defaultValue);
            return defaultValue;
        }
    }

    /**
     * Convertit une chaîne de caractères en énumération de manière sécurisée
     * @param enumClass Classe de l'énumération
     * @param value Valeur à convertir
     * @return Valeur énumérée ou la première valeur disponible si la conversion échoue
     */
    public static <E extends Enum<E>> E parseEnum(Class<E> enumClass, String value) {
        if (value == null || value.trim().isEmpty()) {
            E[] values = enumClass.getEnumConstants();
            return values.length > 0 ? values[0] : null;
        }

        try {
            return Enum.valueOf(enumClass, value.trim().toUpperCase());
        } catch (IllegalArgumentException | NullPointerException e) {
            System.out.println("⚠️ Valeur invalide pour " + enumClass.getSimpleName() + ": '" + value +
                             "'. Utilisation de la première valeur disponible.");
            E[] values = enumClass.getEnumConstants();
            return values.length > 0 ? values[0] : null;
        }
    }
}

