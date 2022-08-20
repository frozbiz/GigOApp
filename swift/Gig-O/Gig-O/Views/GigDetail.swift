//
//  GigDetail.swift
//  Gig-O
//
//  Created by Lee Keyser-Allen on 8/16/22.
//

import SwiftUI

//struct GigDetailRow<Col1Cont,Col2Cont,Col3Cont>: View where Col1Cont : View, Col2Cont : View, Col3Cont : View {
//    var first : Col1Cont
//    var second : Col2Cont
//    var third : Col3Cont
//    var body: some View {
//        GridRow {
//            first
//            second
//            third
//        }
//    }
//    @inlinable public init(@ViewBuilder content: () -> Col1Cont, @ViewBuilder col2: () -> Col2Cont, @ViewBuilder col3: () -> Col3Cont) {
//        first  = content()
//        second = col2()
//        third  = col3()
//    }
//}

struct GigDetailRow<Col1Cont,Col2Cont>: View where Col1Cont : View, Col2Cont : View {
    var first : Col1Cont
    var second : Col2Cont
    var body: some View {
        GridRow {
            first
                .padding(.horizontal)
                .padding(.vertical, 5.0)

            second
//                .padding(.horizontal)
                .gridCellColumns(2)
                .frame(maxWidth: .infinity, alignment: .leading)

//            HStack {
//                second
////                .border(.black, width: 1.0)
////                Spacer(minLength: 0)
//            }
//            .gridCellColumns(2)
        }
    }

    @inlinable public init(@ViewBuilder content: () -> Col1Cont, @ViewBuilder col2: () -> Col2Cont) {
        first  = content()
        second = col2()
    }

}


struct GigDetail: View {
    var gig : Gig
    var body: some View {
        ScrollView {
            Grid(alignment: .leading) {
                HStack {
                    Text("Info")
                        .padding(.horizontal)
                        .padding(.vertical, 5.0)
//                        .padding(EdgeInsets(top: 2.5, leading: 5.0, bottom: 2.5, trailing: 5.0))
//                    Spacer().gridCellUnsizedAxes([.horizontal])
//                    Button {
//
//                    } label: {
//                        Text("Edit")
//                            .foregroundColor(.white)
//                            .padding(EdgeInsets(top: 2.5, leading: 5.0, bottom: 2.5, trailing: 5.0))
//                    }
//                    .background(.blue)
//                    .clipShape(RoundedRectangle(cornerRadius: 4.0))
//                    .padding(.horizontal, 5.0)
//                    Button {
//
//                    } label: {
//                        Text("Duplicate")
//                            .foregroundColor(.white)
//                            .padding(EdgeInsets(top: 2.5, leading: 5.0, bottom: 2.5, trailing: 5.0))
//                    }
//                    .background(.blue)
//                    .clipShape(RoundedRectangle(cornerRadius: 4.0))
//                    .padding(.horizontal, 5.0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 1.0, saturation: 0.017, brightness: 0.857)/*@END_MENU_TOKEN@*/)
                GigDetailRow {
                    Text("Gig")
                } col2: {
                    Text(gig.name)
                        .fontWeight(.semibold)
                }
                GigDetailRow {
                    Color.clear
                        .gridCellUnsizedAxes([.horizontal])
                } col2: {
                    HStack {
                        gig.gigStatus.icon
                        Text(gig.gigStatus.name)
                    }
                    .padding(.bottom, 5.0)
                    //                    .frame(maxWidth: .infinity)
                }
                GigDetailRow {
                    Image(systemName: "calendar")
                } col2: {
                    let df = DateFormatter()
                    let _ = df.dateFormat = "EEEE, MMMM dd, yyyy"
                    if let dateValue = gig.dateValue {
                        Text(df.string(from: dateValue))
                    } else {
                        Text("Date Unset")
                    }
                }
                Image(systemName: "clock.fill")
                    .padding(.horizontal)
                    .padding(.vertical, 4.0)
                GridRow {
                    VStack {
                        Text("Call Time")
                        Text(gig.callTimeString)
                    }
                    .frame(maxWidth: .infinity)
                    VStack {
                        Text("Set Time")
                        Text(gig.setTimeString)
                    }
                    .frame(maxWidth: .infinity)
                    VStack {
                        Text("End Time")
                        Text(gig.endTimeString)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom)
            .clipShape(RoundedRectangle(cornerRadius: 4.0))
            .overlay {
                RoundedRectangle(cornerRadius: 4.0).stroke(.gray, lineWidth: 1.0)
            }
            Grid(alignment: .leading) {
                HStack {
                    Text("Plans")
                        .padding(.horizontal)
                        .padding(.vertical, 5.0)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(/*@START_MENU_TOKEN@*//*@PLACEHOLDER=View@*/Color(hue: 1.0, saturation: 0.017, brightness: 0.857)/*@END_MENU_TOKEN@*/)
//                ForEach(gig.)
            }
        }

        .padding()
        .navigationTitle("Gig Info")
    }
}

struct GigDetail_Previews: PreviewProvider {
    static let modelData = ModelData()
    static var previews: some View {
        NavigationView {
            GigDetail(gig:modelData.gigs[0])
        }
    }
}
