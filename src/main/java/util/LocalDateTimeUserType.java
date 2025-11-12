package util;

import java.time.LocalDateTime;

/**
 * Utility class for handling LocalDateTime conversions.
 * Note: The actual handling of zero dates is managed by Hibernate configuration
 * via the JDBC parameter: zeroDateTimeBehavior=convertToNull
 */
public class LocalDateTimeUserType {

    /**
     * Safely convert a LocalDateTime that might be problematic
     */
    public static LocalDateTime safeConvert(LocalDateTime dateTime) {
        // Return null if the date is the epoch/zero date
        if (dateTime == null) {
            return null;
        }

        // Check if it's a zero date (1970-01-01)
        if (dateTime.getYear() == 1970 && dateTime.getMonthValue() == 1 && dateTime.getDayOfMonth() == 1) {
            return null;
        }

        return dateTime;
    }
}

