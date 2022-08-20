//
//  AgendaView.swift
//  Gig-O
//
//  Created by Lee Keyser-Allen on 8/19/22.
//

import SwiftUI

struct AgendaView: View {
    @EnvironmentObject var modelData : ModelData

    var futureGigs: [Gig] {
        modelData.gigs.filter { gig in
            gig.dateValue != nil && gig.dateValue! > Date.now
        }
    }
    var respondedUpcomingGigs: [Gig] {
        futureGigs.filter { gig in
            (gig.userPlan ?? 0) > 0
        }
    }

    var unrespondedUpcomingGigs: [Gig] {
        futureGigs.filter { gig in
            (gig.userPlan ?? 0) == 0
        }
    }

    var body: some View {
        List {
            GigListView(gigs: unrespondedUpcomingGigs, heading: "Future Gigs: Weigh In!")
            GigListView(gigs: respondedUpcomingGigs, heading: "All Upcoming Gigs", briefHeading: "My Next Few Gigs", showBrief: true)
        }
        .navigationTitle("Schedule: \(modelData.user?.name ?? "SampleUser")")
        .toolbar {
            Button {
                Task {
                    await GigOApi.logOut()
                    modelData.user = nil
                }
            } label: {
                Text("Log Out")
            }
        }
    }
}

struct AgendaView_Previews: PreviewProvider {
    static private let modelData = ModelData()
    static var previews: some View {
        //Use this if NavigationBarTitle is with Large Font
        let _ = UINavigationBar.appearance().largeTitleTextAttributes = [.font: UIFont.preferredFont(forTextStyle: .title1)]

        NavigationView {
            AgendaView()
                .environmentObject(modelData)
        }
        .navigationViewStyle(.columns)
    }
}
