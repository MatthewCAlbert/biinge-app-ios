//
//  NSDate+Ext.swift
//  Biinge
//
//  Created by Matthew Christopher Albert on 11/04/22.
//

import Foundation

extension NSDate {

    func isGreaterThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isGreater = false

        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedDescending {
            isGreater = true
        }

        //Return Result
        return isGreater
    }

    func isLessThanDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isLess = false

        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedAscending {
            isLess = true
        }

        //Return Result
        return isLess
    }

    func equalToDate(dateToCompare: NSDate) -> Bool {
        //Declare Variables
        var isEqualTo = false

        //Compare Values
        if self.compare(dateToCompare as Date) == ComparisonResult.orderedSame {
            isEqualTo = true
        }

        //Return Result
        return isEqualTo
    }

    func addDays(daysToAdd: Int) -> NSDate {
        let secondsInDays: TimeInterval = Double(daysToAdd) * 60 * 60 * 24
        let dateWithDaysAdded: NSDate = self.addingTimeInterval(secondsInDays)

        //Return Result
        return dateWithDaysAdded
    }

    func addHours(hoursToAdd: Int) -> NSDate {
        let secondsInHours: TimeInterval = Double(hoursToAdd) * 60 * 60
        let dateWithHoursAdded: NSDate = self.addingTimeInterval(secondsInHours)

        //Return Result
        return dateWithHoursAdded
    }
    
    func addMinutes(minutesToAdd: Int) -> NSDate {
        let secondsInMinutes: TimeInterval = Double(minutesToAdd) * 60
        let dateWithMinutesAdded: NSDate = self.addingTimeInterval(secondsInMinutes)

        //Return Result
        return dateWithMinutesAdded
    }
    
    func addSeconds(secondsToAdd: Int) -> NSDate {
        let dateWithSecondsAdded: NSDate = self.addingTimeInterval(Double(secondsToAdd))

        //Return Result
        return dateWithSecondsAdded
    }
}
