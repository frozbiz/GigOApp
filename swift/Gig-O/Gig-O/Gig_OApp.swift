//
//  Gig_OApp.swift
//  Gig-O
//
//  Created by Lee Keyser-Allen on 8/16/22.
//

import SwiftUI

@main
struct Gig_OApp: App {
    @StateObject private var modelData = ModelData()
    var body: some Scene {
        WindowGroup {
//            LogInView()
            ContentView()
                .environmentObject(modelData)
        }
    }
}
