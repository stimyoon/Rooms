//
//  LocationGridView.swift
//  Rooms
//
//  Created by Tim Yoon on 10/2/22.
//

import SwiftUI
enum RoomStatus {
    case open, closed
}
struct Item: Identifiable {
    var id = UUID()
    var name = ""
}
struct Location: Identifiable {
    var id = UUID()
    var name = ""
    var status : RoomStatus = .open
    var items : [Item] = []
}

class LocationsViewModel : ObservableObject {
    @Published var grid : [[Location]] = [[]]
    @Published private(set) var col = 0
    @Published private(set) var row = 0
    
    static let rowMax = 5
    static let colMax = 4
    init(){
        self.grid = Array(repeating: Array(repeating: Location(), count: LocationsViewModel.colMax), count: LocationsViewModel.rowMax)
        for row in 0..<LocationsViewModel.rowMax {
            for col in 0..<LocationsViewModel.colMax {
                grid[row][col].name = String("Room: \(row*LocationsViewModel.rowMax + col)")
            }
        }
        
    }
    func move(direction: Direction){
        switch direction {
            
        case .north:
            let newRow = row - 1
            if newRow >= 0 {
                row = newRow
            }
        case .east:
            let newCol = col + 1
            if newCol < LocationsViewModel.colMax {
                col = newCol
            }
        case .south:
            let newRow = row + 1
            if newRow < LocationsViewModel.rowMax {
                row = newRow
            }
        case .west:
            let newCol = col - 1
            if newCol >= 0 {
                col = newCol
            }
        }
    }
}
struct LocationGridView: View {
    @StateObject var vm = LocationsViewModel()
    
    var body: some View {
        VStack{
            Text("\(vm.grid[vm.row][vm.col].name)")
            Spacer()
            VStack{
                Button {
                    vm.move(direction: .north)
                } label: {
                    Text("North")
                }
                HStack{
                    Button {
                        vm.move(direction: .west)
                    } label: {
                        Text("West")
                    }
                    Button {
                        vm.move(direction: .east)
                    } label: {
                        Text("East")
                    }
                }
                Button {
                    vm.move(direction: .south)
                } label: {
                    Text("South")
                }
            }

        }
    }
}

struct Locations_Previews: PreviewProvider {
    static var previews: some View {
        LocationGridView()
    }
}
