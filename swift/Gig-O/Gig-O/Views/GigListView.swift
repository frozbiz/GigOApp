//
//  GigListView.swift
//  Gig-O
//
//  Created by Lee Keyser-Allen on 8/16/22.
//

import SwiftUI

struct GigListView: View {
    var gigs: [Gig]
    var heading = "Upcoming Gigs"
    var briefHeading : String?
    var showBrief = false
    @State private var brief = false
    var filteredGigs: ArraySlice<Gig> {
        if brief {
            return gigs.prefix(5)
        }
        return gigs.dropFirst(0)
    }
    var body: some View {
        Section {
            ForEach (filteredGigs) { gig in
                NavigationLink {
                    GigDetail(gig: gig)
                } label: {
                    GigView(gig: gig)
                }
            }
        } header: {
            VStack (alignment: .leading) {
                Text((brief ? briefHeading : nil) ?? heading)
                if showBrief {
                    Toggle(isOn: $brief) {
                        Text("Brief")
                    }
                }
            }
        }
        .headerProminence(.increased)
    }
}

struct GigListView_Previews: PreviewProvider {
    static let modelData = ModelData()
    static var previews: some View {
        NavigationView {
            List {
                GigListView(gigs:modelData.gigs, briefHeading: "Upcoming Gigs (brief)", showBrief: true)
            }
        }.previewLayout(.fixed(width: 300, height: 300))
    }
}
