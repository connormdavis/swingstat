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
    @State var totalSwings: Int = 0
    @State var percentPassed: Double = 0.0
    @State var mostPassed: String = "Not available"
    @State var leastPassed: String = "Not available"
    @State var leftArmAnglePct: Double = 0.0
    @State var hipSwayPct: Double = 0.0
    @State var swingTempoPct: Double = 0.0
    @State var vertHeadPct: Double = 0.0
    @State var latHeadPct: Double = 0.0

    
    func populateSavedSwings() {
        Task {
            await SavedSwingAnalysis.retrieveAllSavedSwings(handler: swingsRetrieved)
            print("-----> RETRIEVING SWINGS FROM BACKEND")
        }
    }
    
    func swingsRetrieved(swings: [Swing]) {
        self.savedSwings = swings
        print("-----> swings array filled: \(savedSwings)")
        populateStats(swings: savedSwings)
        print("-----> populateStats() called")
        
    }
    

    func populateStats(swings: [Swing]) {

        // total swings
        self.totalSwings = swings.count
        print(totalSwings)
        
        var numPassed = 0.0
        
        var leftArmPassedCount = 0
        var hipSwayPassedCount = 0
        var swingTempoPassedCount = 0
        var vertHeadPassedCount = 0
        var latHeadPassedCount = 0

        // probably going to want to only loop through swings once and fill out the variables as we go
        if totalSwings >= 1 {
            for swing in swings {
                for tip in swing.swingTips {
                    // check every swing tip
                    if tip.type == "Swing tempo" && tip.passed {
                        numPassed += 1.0
                        swingTempoPassedCount += 1
                    }
                    else if tip.type == "Left arm angle" && tip.passed {
                        numPassed += 1.0
                        leftArmPassedCount += 1
                    }
                    else if tip.type == "Hip sway" && tip.passed {
                        numPassed += 1.0
                        hipSwayPassedCount += 1
                    }
                    else if tip.type == "Vertical head movement" && tip.passed {
                        numPassed += 1.0
                        vertHeadPassedCount += 1
                    }
                    else if tip.type == "Lateral head movement" && tip.passed {
                        numPassed += 1.0
                        latHeadPassedCount += 1
                    }
                }
            }
        }
        print("numPassed: \(numPassed)")
        
        let tipDict = ["Swing tempo": swingTempoPassedCount, "Left arm angle": leftArmPassedCount, "Hip sway": hipSwayPassedCount, "Vertical head movement": vertHeadPassedCount, "Lateral head movement": latHeadPassedCount]
       
        var maxStr = "None"
        var minStr = "None"
        var maxInt = 0
        var minInt = 999
        for (string, value) in tipDict {
            
            if value > maxInt {
                maxStr = string
                maxInt = value
            }
            else if value < minInt {
                minStr = string
                minInt = value
            }
        }
                    
        self.percentPassed =  numPassed / (Double(self.totalSwings) * 5.0) * 100
        self.mostPassed = maxStr
        self.leastPassed = minStr
        self.leftArmAnglePct = Double(leftArmPassedCount) / Double(self.totalSwings) * 100
        self.hipSwayPct = Double(hipSwayPassedCount) / Double(self.totalSwings) * 100
        self.swingTempoPct = Double(swingTempoPassedCount) / Double(self.totalSwings) * 100
        self.vertHeadPct = Double(vertHeadPassedCount) / Double(self.totalSwings) * 100
        self.latHeadPct = Double(latHeadPassedCount) / Double(self.totalSwings) * 100
    }
    
    var body: some View {

        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Overview")) {
                        HStack {
                            Text("Swings Analyzed")
                            Spacer()
                            Text("\(totalSwings)")
                        }
                        HStack {
                            Text("Percent Passed")
                            Spacer()
                            if percentPassed > 66.666 {
                                Text("\(percentPassed, specifier: "%.1f")%")
                                    .foregroundColor(.green)
                            } else if percentPassed < 33.333 {
                                Text("\(percentPassed, specifier: "%.1f")%")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(percentPassed, specifier: "%.1f")%")
                                    .foregroundColor(.yellow)
                            }
                        }
                        HStack {
                            Text("Most Passed")
                            Spacer()
                            Text("\(mostPassed)")
                        }
                        HStack {
                            Text("Least Passed")
                            Spacer()
                            Text("\(leastPassed)")
                        }
                    }
                    Section(header: Text("Percent Passed by Tip")) {
                        HStack {
                            Text("Left Arm Angle")
                            Spacer()
                            if leftArmAnglePct > 66.666 {
                                Text("\(leftArmAnglePct, specifier: "%.1f")%")
                                    .foregroundColor(.green)
                            } else if leftArmAnglePct < 33.333 {
                                Text("\(leftArmAnglePct, specifier: "%.1f")%")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(leftArmAnglePct, specifier: "%.1f")%")
                                    .foregroundColor(.yellow)
                            }
                        }
                        HStack {
                            Text("Hip Sway")
                            Spacer()
                            if hipSwayPct > 66.666 {
                                Text("\(hipSwayPct, specifier: "%.1f")%")
                                    .foregroundColor(.green)
                            } else if hipSwayPct < 33.333 {
                                Text("\(hipSwayPct, specifier: "%.1f")%")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(hipSwayPct, specifier: "%.1f")%")
                                    .foregroundColor(.yellow)
                            }
                        }
                        HStack {
                            Text("Swing Tempo")
                            Spacer()
                            if swingTempoPct > 66.666 {
                                Text("\(swingTempoPct, specifier: "%.1f")%")
                                    .foregroundColor(.green)
                            } else if swingTempoPct < 33.333 {
                                Text("\(swingTempoPct, specifier: "%.1f")%")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(swingTempoPct, specifier: "%.1f")%")
                                    .foregroundColor(.yellow)
                            }
                        }
                        HStack {
                            Text("Vertical Head Movement")
                            Spacer()
                            if vertHeadPct > 66.666 {
                                Text("\(vertHeadPct, specifier: "%.1f")%")
                                    .foregroundColor(.green)
                            } else if vertHeadPct < 33.333 {
                                Text("\(vertHeadPct, specifier: "%.1f")%")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(vertHeadPct, specifier: "%.1f")%")
                                    .foregroundColor(.yellow)
                            }
                        }
                        HStack {
                            Text("Lateral Head Movement")
                            Spacer()
                            if latHeadPct > 66.666 {
                                Text("\(latHeadPct, specifier: "%.1f")%")
                                    .foregroundColor(.green)
                            } else if latHeadPct < 33.333 {
                                Text("\(latHeadPct, specifier: "%.1f")%")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(latHeadPct, specifier: "%.1f")%")
                                    .foregroundColor(.yellow)
                            }
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
