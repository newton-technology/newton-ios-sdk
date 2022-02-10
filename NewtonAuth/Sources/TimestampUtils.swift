//
//  File.swift
//  
//
//  Created by Mihail Kuznetsov on 12.01.2022.
//

import Foundation

class TimestampUtils {
    
    private static let HeaderKeyDate = "date"
    
    public static func getExpirationTimeInSeconds(timestampInSeconds: Double?, httpHeaders: [AnyHashable : Any]?) -> Double? {
        guard let ts = timestampInSeconds else {
            return nil
        }
        guard let headers = httpHeaders else {
            return ts
        }
        return getTimestampInLocalTime(timestamp: ts, headers: headers)
    }
    
    public static func getTimestampInLocalTime(timestamp: Double, headers: [AnyHashable : Any]) -> Double {
        guard let dateKey = headers.keys.first(where: {($0 as! String).caseInsensitiveCompare(HeaderKeyDate) == .orderedSame }),
              let dateString = headers[dateKey] as? String,
              let headerDate = getDateFromString(dateString: dateString) else {
            return timestamp
        }
        let now = Date()
        let delta = now.timeIntervalSince1970 - headerDate.timeIntervalSince1970
        return timestamp + delta
    }
    
    public static func getDateFromString(dateString: String) -> Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "en_US")
        dateFormatter.dateFormat = "E, d MMM yyyy HH:mm:ss ZZZZ"
        return dateFormatter.date(from: dateString)
    }
    
    private static func getTimeInSeconds(timestamp: Double?) -> Double? {
        guard let ts = timestamp else {
            return nil
        }
        return ts / 1000
    }
}
