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
    var totalSwings: Int = 0
    var percentPassed: Double = 0.0
    var mostPassed: String = "N/A"
    var leastPassed: String = "N/A"
    var leftArmAnglePct: Double = 0.0
    var hipSwayPct: Double = 0.0
    var swingTempoPct: Double = 0.0
    var vertHeadPct: Double = 0.0
    var latHeadPct: Double = 0.0

    
    func populateSavedSwings() {
        Task {
            await SavedSwingAnalysis.retrieveAllSavedSwings(handler: swingsRetrieved)
            print("-----> RETRIEVING SWINGS FROM BACKEND")
        }
    }
    
    func swingsRetrieved(swings: [Swing]) {
        self.savedSwings = swings
    }
    

    mutating func populateStats(swings: [Swing]) {

        // total swings
        self.totalSwings = swings.count
        
        var numPassed = 0.0
        
        var leftArmPassedCount = 0
        var hipSwayPassedCount = 0
        var swingTempoPassedCount = 0
        var vertHeadPassedCount = 0
        var latHeadPassedCount = 0

        // probably going to want to only loop through swings once and fill out the variables as we go
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
                    
        self.percentPassed =  numPassed / Double(self.totalSwings) * 5.0
        self.mostPassed = maxStr
        self.leastPassed = minStr
        self.leftArmAnglePct = Double(leftArmPassedCount) / Double(self.totalSwings)
        self.hipSwayPct = Double(hipSwayPassedCount) / Double(self.totalSwings)
        self.swingTempoPct = Double(swingTempoPassedCount) / Double(self.totalSwings)
        self.vertHeadPct = Double(vertHeadPassedCount) / Double(self.totalSwings)
        self.latHeadPct = Double(latHeadPassedCount) / Double(self.totalSwings)
    }
    
    var body: some View {
        NavigationView{
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
                            if percentPassed >= 75 {
                                Text("\(percentPassed, specifier: "%.2f")")
                                    .foregroundColor(.green)
                            } else if percentPassed < 25 {
                                Text("\(percentPassed, specifier: "%.2f")")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(percentPassed, specifier: "%.2f")")
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
                            if leftArmAnglePct >= 75 {
                                Text("\(leftArmAnglePct, specifier: "%.2f")")
                                    .foregroundColor(.green)
                            } else if leftArmAnglePct < 25 {
                                Text("\(leftArmAnglePct, specifier: "%.2f")")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(leftArmAnglePct, specifier: "%.2f")")
                                    .foregroundColor(.yellow)
                            }
                        }
                        HStack {
                            Text("Hip Sway")
                            Spacer()
                            if hipSwayPct >= 75 {
                                Text("\(hipSwayPct, specifier: "%.2f")")
                                    .foregroundColor(.green)
                            } else if hipSwayPct < 25 {
                                Text("\(hipSwayPct, specifier: "%.2f")")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(hipSwayPct, specifier: "%.2f")")
                                    .foregroundColor(.yellow)
                            }
                        }
                        HStack {
                            Text("Swing Tempo")
                            Spacer()
                            if swingTempoPct >= 75 {
                                Text("\(swingTempoPct, specifier: "%.2f")")
                                    .foregroundColor(.green)
                            } else if swingTempoPct < 25 {
                                Text("\(swingTempoPct, specifier: "%.2f")")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(swingTempoPct, specifier: "%.2f")")
                                    .foregroundColor(.yellow)
                            }
                        }
                        HStack {
                            Text("Vertical Head Movement")
                            Spacer()
                            if vertHeadPct >= 75 {
                                Text("\(vertHeadPct, specifier: "%.2f")")
                                    .foregroundColor(.green)
                            } else if vertHeadPct < 25 {
                                Text("\(vertHeadPct, specifier: "%.2f")")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(vertHeadPct, specifier: "%.2f")")
                                    .foregroundColor(.yellow)
                            }
                        }
                        HStack {
                            Text("Lateral Head Movement")
                            Spacer()
                            if latHeadPct >= 75 {
                                Text("\(latHeadPct, specifier: "%.2f")")
                                    .foregroundColor(.green)
                            } else if latHeadPct < 25 {
                                Text("\(latHeadPct, specifier: "%.2f")")
                                    .foregroundColor(.red)
                            } else {
                                Text("\(latHeadPct, specifier: "%.2f")")
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
