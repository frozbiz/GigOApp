//
//  Plan.swift
//  Gig-O
//
//  Created by Lee Keyser-Allen on 8/18/22.
//

import Foundation

class Plan : Codable, Identifiable, Hashable {
    var id: String
    var value: Int
    var comment: String?
    var sectionId: String?

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(value)
        hasher.combine(comment)
    }

    static func == (lhs: Plan, rhs: Plan) -> Bool {
        lhs.id == rhs.id &&
        lhs.value == rhs.value &&
        lhs.comment == rhs.comment
    }
}

class MemberPlan : Codable, Hashable {
    var memberId: String
    var memberName: String
    var plan: Plan

    func hash(into hasher: inout Hasher) {
        hasher.combine(memberId)
        hasher.combine(plan)
    }

    static func == (lhs: MemberPlan, rhs: MemberPlan) -> Bool {
        lhs.memberId == rhs.memberId &&
        lhs.plan == rhs.plan
    }
}
