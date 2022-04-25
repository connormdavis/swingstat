//
//  Settings.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 2/23/22.
//

import SwiftUI


fileprivate enum OpenSetting {
    case none, start, end
}


struct Settings: View {
    // User info variables
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var userFeet = 0
    @State private var userInches = 0
    @State private var openSetting = OpenSetting.none

    // Display settings variables
    @State private var darkMode = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationView {
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

                    
                        HeightSetting(title: "User Height",
                                      feet: userFeet,
                                      inches: userInches,
                                      setting: .start,
                                      openSetting: $openSetting)
                        if openSetting == .start {
                            HeightPicker(feet: $userFeet, inches: $userInches)
                            
                        }
                    }

                    Section(header: Text("Display")) {
                        Toggle(isOn: $darkMode,
                               label:{
                            Text("Dark Mode")
                        })
                    }
                    
                }
                .navigationTitle("Settings")
            }
        }
    }
}

// Custom view that will hold the height
struct HeightSetting: View {
    var title: String
    var feet: Int
    var inches: Int
    fileprivate var setting: OpenSetting
    fileprivate var openSetting: Binding<OpenSetting>

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
                self.openSetting.wrappedValue = (self.openSetting.wrappedValue == self.setting) ? OpenSetting.none : self.setting
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

//    var body: some View {
//        GeometryReader { geometry in
//            HStack() {
//                VStack {
//                    Picker(selection: feet, label: EmptyView()) {
//                        ForEach((0...7), id: \.self) { ix in
//                            Text("\(ix)").tag(ix)
//                        }
//                    }
//
//                    .pickerStyle(.wheel).frame(width: geometry.size.width/2.5, height: geometry.size.height, alignment: .center).compositingGroup().clipped()
//
//                }
//                Text("ft.")
//                VStack {
//                    Picker(selection: inches, label: EmptyView()) {
//                        ForEach((0...11), id: \.self) { ix in
//                            Text("\(ix)").tag(ix)
//                        }
//                    }
//                    .pickerStyle(.wheel).frame(width: geometry.size.width/2.5, height: geometry.size.height, alignment: .center).compositingGroup().clipped()
//                }
//                Text("in.")
//            }
//        }
//
//    }
    var body: some View {
            HStack() {
                Spacer()
                Picker(selection: feet, label: EmptyView()) {
                    ForEach((2...7), id: \.self) { ix in
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


struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}
