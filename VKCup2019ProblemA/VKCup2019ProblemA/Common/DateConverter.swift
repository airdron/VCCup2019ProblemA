//
//  DateConverter.swift
//  VKCup2019ProblemA
//
//  Created by Andrew Oparin on 19.02.2020.
//  Copyright © 2020 Andrew Oparin. All rights reserved.
//

import Foundation

final class DateConverter {
    
    private struct DateInfo {
        
        let currentDate = Date()
        let documentDate: Date
        let isIdenticalYear: Bool
        let isIdenticalMonth: Bool
        let isIdenticalDay: Bool
        let isPreviousDay: Bool
        
        init(interval: TimeInterval) {
            documentDate = Date(timeIntervalSince1970: interval)
            
            let documentDateComponents = Self.components(date: documentDate)
            let currentDateComponents = Self.components(date: currentDate)
            
            isIdenticalYear = currentDateComponents.year == documentDateComponents.year
            isIdenticalMonth = currentDateComponents.month == documentDateComponents.month
            isIdenticalDay = currentDateComponents.day == documentDateComponents.day
            
            if let today = documentDateComponents.day, let documentDay = currentDateComponents.day {
                isPreviousDay = (today - documentDay) == 1
            } else {
                isPreviousDay = false
            }
        }
        
        private static func components(date: Date) -> DateComponents {
            let calendar = Calendar(identifier: .gregorian)
            return calendar.dateComponents([.year, .month, .day, .hour, .minute], from: date)
        }
    }
    
    private let formatter = DateFormatter()

    func documentFormatedDate(interval: TimeInterval) -> String {
        
        let dateInfo = DateInfo(interval: interval)
        
        let formattedDate: String
        
        if dateInfo.isIdenticalYear, dateInfo.isIdenticalMonth, dateInfo.isIdenticalDay {
            formattedDate = L10n.documentsDateToday
        } else if dateInfo.isIdenticalYear, dateInfo.isIdenticalMonth, dateInfo.isPreviousDay {
            formattedDate = L10n.documentsDateYesterday
        } else if dateInfo.isIdenticalYear {
            formatter.dateFormat = "d MMM"
            formattedDate = formatter.string(from: dateInfo.documentDate)
        } else {
            formatter.dateFormat = "d MMM yy"
            formattedDate = formatter.string(from: dateInfo.documentDate)
        }
        
        return formattedDate.replacingOccurrences(of: ".", with: "")
    }
}
