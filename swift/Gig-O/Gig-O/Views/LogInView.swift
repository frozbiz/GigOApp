//
//  LogInView.swift
//  Gig-O
//
//  Created by Lee Keyser-Allen on 8/19/22.
//

import SwiftUI

struct LogInView: View {
    @State private var isloggedIn = false

    func updateLoggedIn() {
        Task {
            isloggedIn = await GigOApi.loggedIn()
        }
    }
    var body: some View {
        VStack {
            Spacer()
            Button {
                Task {
                    isloggedIn = await GigOApi.logIn(username: "gigOTestUser@gmail.com", password: "mycoolpassword")
                }
            } label: {
                Text("Log In Test User")
            }

            Spacer()
            Text(isloggedIn ? "Logged in!" : "Not Logged In.")
            Spacer()
            Button {
                updateLoggedIn()
            } label: {
                Text("Check Logged in")
            }
            Spacer()
            Button {
                Task {
                    try await URLSession.shared.data(from: URL(string: "https://www.google.com")!)
                }
            } label: {
                Text("Visit Google")
            }
            Spacer()
        }
        .onAppear {
            updateLoggedIn()
        }
    }
}

struct LogInView_Previews: PreviewProvider {
    static var previews: some View {
        LogInView()
    }
}
