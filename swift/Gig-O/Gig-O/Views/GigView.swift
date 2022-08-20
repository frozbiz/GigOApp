//
//  GigView.swift
//  Gig-O
//
//  Created by Lee Keyser-Allen on 8/16/22.
//

import SwiftUI

struct GigView: View {
    @State var gig: Gig

    func iconWithUserPlan(planVal: Int?) -> some View {
        UserPlan(rawValue: planVal ?? 0)?.icon ?? UserPlan.unset.icon
    }
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(gig.dateString)
            }
            Text(gig.name)
                .fontWeight(.bold)
                .foregroundColor(Color.blue)
            Menu {
                Picker(selection: $gig.userPlan, label: EmptyView()) {
                    ForEach(UserPlan.allCases, id: \.rawValue) { plan in
                        HStack {
                            Text(plan.name)
                            plan.icon
                        }.tag(plan.rawValue)
                    }
                }
            } label: {
                HStack {
                    gig.userPlanEnum.icon
                    Image(systemName: "chevron.up.chevron.down")
                }.foregroundColor(.black)
            }
        }
    }
}

struct GigView_Previews: PreviewProvider {
    static let modelData = ModelData()
    static var previews: some View {
        Group {
            GigView(gig: modelData.gigs[0])
            GigView(gig: modelData.gigs[2])
        }
        .previewLayout(.fixed(width: 300, height: 70))
    }
}
