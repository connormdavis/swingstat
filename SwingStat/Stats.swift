//
//  Stats.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 2/23/22.
//

import SwiftUI

struct Stats: View {
    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Overview")) {
                        HStack {
                            Text("Swings Analyzed")
                            Spacer()
                            Text("43")
                        }
                        HStack {
                            Text("Percent Passed")
                            Spacer()
                            Text("58%")
                        }
                        HStack {
                            Text("Most Passed")
                            Spacer()
                            Text("Vert Head Movement (89%)")
                        }
                        HStack {
                            Text("Least Passed")
                            Spacer()
                            Text("Hip Sway (18%)")
                        }
                    }
                    Section(header: Text("Percent Passed by Tip")) {
                        HStack {
                            Text("Left Arm Angle")
                            Spacer()
                            Text("75%")
                        }
                        HStack {
                            Text("Hip Sway")
                            Spacer()
                            Text("18%")
                        }
                        HStack {
                            Text("Swing Tempo")
                            Spacer()
                            Text("72%")
                        }
                        HStack {
                            Text("Vertical Head Movement")
                            Spacer()
                            Text("89%")
                        }
                        HStack {
                            Text("Lateral Head Movement")
                            Spacer()
                            Text("84%")
                        }
                    }
                }
                .font(.subheadline)
            }
            .navigationTitle("Swing Statistics")
        }
    }
}

struct Stats_Previews: PreviewProvider {
    static var previews: some View {
        Stats()
    }
}
