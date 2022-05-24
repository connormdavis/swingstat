//
//  SwingFilterModel.swift
//  SwingStat (iOS)
//
//  Created by Chris Sykes on 5/18/22.
//

import Foundation
import SwiftUI

enum FilterButtonState: Equatable {
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

    var data = [
        SwingFilterData(imageName: "airplane", title: "Tempo", status: .none()),
        SwingFilterData(imageName: "tag.fill", title: "Left Arm", status: .none()),
        SwingFilterData(imageName: "bed.double.fill", title: "Hip Sway", status: .none()),
        SwingFilterData(imageName: "car.fill", title: "Vert Head", status: .none()),
        SwingFilterData(imageName: "car.fill", title: "Lat Head", status: .none())
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
    
    
    // Remakes the published selectionStatus list
    private func refreshSelectionStatus() {
        // add the selected buttons to the selectionStatus array
        let result = data.filter{ $0.status == .passed() || $0.status == .failed() }
//        withAnimation {
            selectionStatus = result
//        }
    }
}
