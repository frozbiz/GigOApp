//
//  ContentView.swift
//  Gig-O
//
//  Created by Lee Keyser-Allen on 8/16/22.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var modelData : ModelData
    @State private var loading = true
    @State private var loggedIn = false

    init() {
        //Use this if NavigationBarTitle is with Large Font
        UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .title1)]
    }

    var body: some View {
        ZStack(alignment: .center) {
            NavigationView {
                AgendaView()
            }
            .navigationViewStyle(.columns)
            .padding()
            if loading {
                Color.white
                Image("tuba")
            }
        }
        .edgesIgnoringSafeArea(.all)
        .onAppear {
            Task {
                loggedIn = await GigOApi.loggedIn()
                withAnimation() {
                    loading = false
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())
    }
}
