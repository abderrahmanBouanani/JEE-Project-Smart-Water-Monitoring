package util;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * Utility class for handling date operations and ensuring no zero dates
 */
public class DateUtil {

    /**
     * Ensures a LocalDateTime is not null. If null or zero, returns current timestamp.
     * @param dateTime the LocalDateTime to check
     * @return the validated LocalDateTime
     */
    public static LocalDateTime ensureNotZeroDateTime(LocalDateTime dateTime) {
        return (dateTime == null) ? LocalDateTime.now() : dateTime;
    }

    /**
     * Ensures a LocalDate is not null. If null or zero, returns current date.
     * @param date the LocalDate to check
     * @return the validated LocalDate
     */
    public static LocalDate ensureNotZeroDate(LocalDate date) {
        return (date == null) ? LocalDate.now() : date;
    }

    /**
     * Validates if a date is acceptable (not zero date)
     * @param dateTime the LocalDateTime to validate
     * @return true if valid, false otherwise
     */
    public static boolean isValidDateTime(LocalDateTime dateTime) {
        return dateTime != null &&
               !dateTime.equals(LocalDateTime.of(0, 1, 1, 0, 0, 0));
    }

    /**
     * Validates if a date is acceptable (not zero date)
     * @param date the LocalDate to validate
     * @return true if valid, false otherwise
     */
    public static boolean isValidDate(LocalDate date) {
        return date != null &&
               !date.equals(LocalDate.of(0, 1, 1));
    }
}

