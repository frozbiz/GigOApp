//
//  Band.swift
//  Gig-O
//
//  Created by Lee Keyser-Allen on 8/18/22.
//

import Foundation

struct BandSection : Codable, Identifiable, Hashable {
    let id: String
    let name: String

    static func == (lhs: BandSection, rhs: BandSection) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

// snake_cased
struct Band : Codable, Identifiable, Hashable {
    let id: String
    let name: String
    let hideFromSchedule: Bool?
    let description: String?
    let defaultSection: String?
    let isOccasional: Bool?
    let shortName: String?
    let sections: [BandSection]

    private enum CodingKeys: String, CodingKey {
        case id
        case name
        case hideFromSchedule = "hide_from_schedule"
        case description
        case defaultSection = "default_section"
        case isOccasional = "is_occasional"
        case shortName = "shortname"
        case sections
    }

    static func == (lhs: Band, rhs: Band) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
