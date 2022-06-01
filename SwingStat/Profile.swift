//
//  Profile.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 2/23/22.
//

import SwiftUI

fileprivate enum HeightOpenSetting {
    case none, start, end
}

fileprivate enum BackswingOpenSetting {
    case none, start, end
}

struct Profile: View {
    // User info variables
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var userFeet = 0
    @State private var userInches = 0
    @State private var heightOpenSetting = HeightOpenSetting.none
    
    // Swing info variables
    @State private var swingTempo = 1.0
    @State private var backswingOpenSetting = BackswingOpenSetting.none
    
    @Binding var loggedOut: Bool

    
    
    var body: some View {
        
        NavigationView {
            VStack {
                VStack {
                    if !(firstName.isEmpty) && !(lastName.isEmpty){
                        Text("\(firstName) \(lastName)")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)
                    } else {
                        Text("SwingStat User")
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .font(.title)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 20)
                Form {
                    Section(header: Text("User Info")) {
                        HStack {
                            Text("First Name")
                            Spacer()
                            TextField("John", text: $firstName).multilineTextAlignment(.trailing)
                        }
                        HStack {
                            Text("Last Name")
                            Spacer()
                            TextField("Doe", text: $lastName).multilineTextAlignment(.trailing)
                        }
                        HeightSetting(title: "Height",
                                      feet: userFeet,
                                      inches: userInches,
                                      heightSetting: .start,
                                      heightOpenSetting: $heightOpenSetting)
                        if heightOpenSetting == .start {
                            HeightPicker(feet: $userFeet, inches: $userInches)
                        }
                        HStack {
                            Text("Member Since")
                            Spacer()
                            Text("5/4/2022")
                        }
                    }
                    Section(header: Text("Swing Info")) {
                        BackswingSetting(title: "Desired Backswing Tempo",
                                         seconds: swingTempo,
                                         backswingSetting: .start,
                                         backswingOpenSetting: $backswingOpenSetting)
                        if backswingOpenSetting == .start {
                            BackswingTempoPicker(seconds: $swingTempo)
                        }
                    }
                    Section(header: Text("App Info")) {
                        HStack {
                            Text("Version")
                            Spacer()
                            Text("1.0")
                        }
                    }
                    Section(header: Text("Logout")) {
                        Button("Logout") {
//                            Authentication().transition(.opacity)
                            loggedOut = true
                            UserData.saveUserId(userId: "")
                        }
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

// Custom view that will hold the desired back swing tempo
struct BackswingSetting: View {
    var title: String
    var seconds: Double
    fileprivate var backswingSetting: BackswingOpenSetting
    fileprivate var backswingOpenSetting: Binding<BackswingOpenSetting>

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            ZStack {
                Text(String(format: "%.1f s", seconds))
            }
            .frame(width: 64, height: 32)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation() {
                self.backswingOpenSetting.wrappedValue = (self.backswingOpenSetting.wrappedValue == self.backswingSetting) ? BackswingOpenSetting.none : self.backswingSetting
            }
        }
    }
}

// Custom view for selecting desired backswing tempo
struct BackswingTempoPicker: View {
    var seconds: Binding<Double>

    let swingTempos = Array(stride(from: 1.0, through: 4.0, by: 0.1))

    var body: some View {
        HStack {
            Picker(selection: seconds, label: EmptyView()) {
                ForEach(swingTempos, id: \.self) {  ix in
                    Text(String(format: "%.1f", ix))
                }
            }
            .pickerStyle(.wheel)
            Text("seconds")
        }
    }
}

// Custom view that will hold the height
struct HeightSetting: View {
    var title: String
    var feet: Int
    var inches: Int
    fileprivate var heightSetting: HeightOpenSetting
    fileprivate var heightOpenSetting: Binding<HeightOpenSetting>

    var body: some View {
        HStack {
            Text(title)
            Spacer()
            ZStack {
                Text(toHeight(feet: feet, inches: inches))
            }
            .frame(width: 64, height: 32)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            withAnimation() {
                self.heightOpenSetting.wrappedValue = (self.heightOpenSetting.wrappedValue == self.heightSetting) ? HeightOpenSetting.none : self.heightSetting
            }
        }
    }

    func toHeight(feet: Int, inches: Int) -> String {
        let heightString = String(format: "%01d'", feet) + " " + String(format: "%01d\"", inches)
        return heightString
    }
}

// Custom view for selecting height in feet and inches side by side
struct HeightPicker: View {
    var feet: Binding<Int>
    var inches: Binding<Int>

    var body: some View {
            HStack() {
                Spacer()
                Picker(selection: feet, label: EmptyView()) {
                    ForEach((0...7), id: \.self) { ix in
                        Text("\(ix)").tag(ix)
                    }
                    }.pickerStyle(WheelPickerStyle()).frame(width: 100).clipped()
                Text("ft.")
                Picker(selection: inches, label: EmptyView()) {
                    ForEach((0...11), id: \.self) { ix in
                        Text("\(ix)").tag(ix)
                    }
                    }.pickerStyle(WheelPickerStyle()).frame(width: 100).clipped()
                Text("in.")
                Spacer()
            }
        }
}


extension UIPickerView {
   open override var intrinsicContentSize: CGSize {
      return CGSize(width: UIView.noIntrinsicMetric, height: super.intrinsicContentSize.height)}
}

//
//struct Profile_Previews: PreviewProvider {
//    static var previews: some View {
//        Profile()
//    }
//}
