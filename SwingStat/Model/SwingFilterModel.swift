//
//  SwingFilterModel.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 5/18/22.
//

import Foundation

//protocol ButtonState: CaseIterable {
//    var title: String {get}
//}
//
//extension ButtonState where Self: RawRepresentable, RawValue == String {
//    var title: String {
//        self.rawValue
//    }
//}

enum FilterButtonState {
    case passed(color: Color = .green)
    case failed(color: Color = .red)
    case none(color: Color = .gray)
    
    var color: Color {
        switch self {
            case .passed(let color):
                return color
            case .failed(let color):
                return color
            case .none(let color):
                return color
        }
    }
}

struct SwingFilterData: Identifiable {
    var id = UUID()
    var imageName: String
    var title: String
    var status: FilterButtonState
}

class SwingFilterModel: NSObject, ObservableObject {
    
    // Normally you would get this data from a remote service, so factor that in if you use
    // this in your own projects. If this data is not static, consider making it @Published
    // so that any changes to it will get reflected by the UI
    var data = [
        SwingFilterData(imageName: "airplane", title: "Tempo"),
        SwingFilterData(imageName: "tag.fill", title: "Left Arm"),
        SwingFilterData(imageName: "bed.double.fill", title: "Hip Sway"),
        SwingFilterData(imageName: "car.fill", title: "Vert Head"),
        SwingFilterData(imageName: "car.fill", title: "Lat Head")

    ]
    
    // These are the FilterData that have been selected using the toggleFilter(at:)
    // function.
    @Published var selectionStatus = [SwingFilterData]()
    
    // Toggles the selection of the filter at the given index
    func toggleFilter(at index: Int, state: FilterButtonState) {
        guard index >= 0 && index < data.count else { return }
        data[index].status = state
        refreshSelectionStatus()
    }
    
//    // Clears the selected items
//    func clearSelection() {
//        for index in 0..<data.count {
//            data[index].isSelected = false
//        }
//        refreshSelection()
//    }
    
    // Remakes the published selectionStatus list
    private func refreshSelectionStatus() {
        // add the selected buttons to the selectionStatus array
        let result = data.filter{ $0.status == FilterButtonState.passed || $0.status == FilterButtonState.failed }
//        withAnimation {
            selectionStatus = result
//        }
    }
}
