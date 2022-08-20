//
//  ModelData.swift
//  Gig-O
//
//  Created by Lee Keyser-Allen on 8/16/22.
//

import Foundation

final class ModelData : ObservableObject {
    @Published var gigs: [Gig] = load("gigData.json")
    @Published var user: User?
    let bands: [Band] = load("bands.json")
}

struct User : Codable, Identifiable, Hashable {
    let id: String
    let name: String

    static func == (lhs: User, rhs: User) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
    else {
        fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}
