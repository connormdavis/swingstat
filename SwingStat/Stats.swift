//
//  Stats.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 2/23/22.
//

import SwiftUI

struct Stats: View {
    
    @State var savedSwings: [Swing] = []
    
    // Stat varaiables
    var totalSwings: Int! = nil
    var percentPassed: Double! = nil
    var mostPassed: String! = nil
    var leastPassed: String! = nil
    var leftArmAnglePct: Double! = nil
    var hipSwayPct: Double! = nil
    var swingTempoPct: Double! = nil
    var vertHeadPct: Double! = nil
    var latHeadPct: Double! = nil
    
    init() {
        self.totalSwings = getTotalSwings(swings: savedSwings)
//        self.percentPassed =
//        self.mostPassed =
//        self.leastPassed =
//        self.leftArmAnglePct =
//        self.hipSwayPct =
//        self.swingTempoPct =
//        self.vertHeadPct =
//        self.latHeadPct =
    }
    
    
    func populateSavedSwings() {
        Task {
            await SavedSwingAnalysis.retrieveAllSavedSwings(handler: swingsRetrieved)
            print("-----> RETRIEVING SWINGS FROM BACKEND")
        }
    }
    
    func swingsRetrieved(swings: [Swing]) {
        self.savedSwings = swings
    }
    

    func getTotalSwings(swings: [Swing]) -> Int {
//        var swingCount = 0
//        for swing in swings {
//            swingCount += 1
//        }
       return swings.count
    }
    
    var body: some View {
        NavigationView{
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
            .onAppear() {
                populateSavedSwings()
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
