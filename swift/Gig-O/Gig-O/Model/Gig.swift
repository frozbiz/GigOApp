//
//  Gig.swift
//  Gig-O
//
//  Created by Lee Keyser-Allen on 8/16/22.
//

import Foundation

struct Gig: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var date: String?
    var description: String
    var status: Int?
    var userPlan: Int?
    var userPlanComment: String?
    var dateValue: Date? {
        if let date {
            let df = DateFormatter()
            df.dateFormat = "MM/dd/yyyy"
            return df.date(from: date)
        } else {
            return nil
        }
    }
    var dateString: String {
        // Convert to a string
        if let dateValue {
            let df = DateFormatter()
            df.dateFormat = "MM/dd/yyyy EEE hh:mma"
            return df.string(from: dateValue)
        } else {
            return "<unset>"
        }
    }
    var userPlanEnum: UserPlan {
        UserPlan(rawValue: userPlan ?? 0) ?? .unset
    }

    var gigStatus: GigStatus {
        GigStatus(rawValue: status ?? 0) ?? .unconfirmed
    }

    var callTimeString: String {
        if let dateValue {
            let df = DateFormatter()
            df.dateFormat = "hh:mma"
            return df.string(from: dateValue)
        } else {
            return "<unset>"
        }
    }

    var setTimeString: String {
        if let dateValue {
            let df = DateFormatter()
            df.dateFormat = "hh:mma"
            let setTime = dateValue.addingTimeInterval(60*30)
            return df.string(from: setTime)
        } else {
            return "<unset>"
        }
    }

    var endTimeString: String {
        if let dateValue {
            let df = DateFormatter()
            df.dateFormat = "hh:mma"
            let endTime = dateValue.addingTimeInterval(60*60*2)
            return df.string(from: endTime)
        } else {
            return "<unset>"
        }
    }
}
