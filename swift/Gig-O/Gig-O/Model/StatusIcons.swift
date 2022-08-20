//
//  StatusIcons.swift
//  Gig-O
//
//  Created by Lee Keyser-Allen on 8/16/22.
//

import Foundation
import SwiftUI

enum GigStatus : Int, CaseIterable, Identifiable {
    case unconfirmed, confirmed, canceled
    var id: Self { self }
    var icon: some View {
        switch self {
        case .unconfirmed:
            return Image(systemName: "questionmark.circle.fill")
                .foregroundColor(.yellow)
        case .confirmed:
            return Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.green)
        case .canceled:
            return Image(systemName: "xmark.circle.fill")
                .foregroundColor(.red)
        }
    }
    var name: String {
        switch self {
        case .unconfirmed: return "Unconfirmed"
        case .confirmed: return "Confirmed!"
        case .canceled: return "Canceled!"
        }
    }
}

enum UserPlan : Int, CaseIterable, Identifiable {
    case unset, definitely, probably, dontknow, probablynot, definitelynot, notinterested
    var id: Self { self }
    var icon: some View {
        switch self {
        case .unset:
            return Image(systemName: "minus")
                .foregroundColor(.black)
        case .definitely:
            return Image(systemName: "circle.fill")
                .foregroundColor(.green)
        case .probably:
            return Image(systemName: "circle")
                .foregroundColor(.green)
        case .dontknow:
            return Image(systemName: "questionmark")
                .foregroundColor(.gray)
        case .probablynot:
            return Image(systemName: "square")
                .foregroundColor(.red)
        case .definitelynot:
            return Image(systemName: "square.fill")
                .foregroundColor(.red)
        case .notinterested:
            return Image(systemName: "xmark")
                .foregroundColor(.black)
        }
    }
    var name: String {
        switch self {
        case .unset: return "No Response"
        case .definitely: return "Definitely"
        case .probably: return "Probably"
        case .dontknow: return "Don't Know"
        case .probablynot: return "Probably Not"
        case .definitelynot: return "Can't Do It"
        case .notinterested: return "Not Interested"
        }
    }
}
