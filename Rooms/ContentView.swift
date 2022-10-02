//
//  ContentView.swift
//  Rooms
//
//  Created by Tim Yoon on 10/2/22.
//

import SwiftUI

enum Direction: Identifiable {
    var id: Self { self }
    case north, east, south, west
}
class Room: Identifiable {
    var id = UUID()
    var roomName = ""
    
    var north : Room?
    var east : Room?
    var south : Room?
    var west : Room?
}
class RoomsVM: ObservableObject {
    @Published var firstRoom : Room = Room()
    @Published var currentRoom : Room = Room()
    
    func addNewRoom(to room: Room, direction: Direction){
        switch direction {
            
        case .north:
            if room.north == nil {
                let newRoom = Room()
                newRoom.south = room
                room.north = newRoom
            } else {
                let tempRoom = room.north
                room.north = Room()
                room.north!.south = room.north
                room.north!.north = tempRoom
            }
        case .east:
            guard let eastRoom = room.east else {
                let newRoom = Room()
                room.east = newRoom
                newRoom.west = room
                return
            }
            let newRoom = Room()
            room.east = newRoom
            newRoom.west = room
            newRoom.east = eastRoom
            
        case .south:
            if room.south == nil {
                let newRoom = Room()
                newRoom.north = room
                room.south = newRoom
            } else {
                let tempRoom = room.south
                room.south = Room()
                room.south!.north = room.south
                room.south!.south = tempRoom
            }
        case .west:
            if room.west == nil {
                let newRoom = Room()
                newRoom.east = room
                room.west = newRoom
            } else {
                let tempRoom = room.west
                let newRoom = Room()
                
                room.west = newRoom
                newRoom.east = room
                newRoom.west = tempRoom
            }
        }
    }
    func moveTo(direction: Direction){
        switch direction {
            
        case .north:
            if let room = currentRoom.north {
                currentRoom = room
            }
        case .east:
            if let room = currentRoom.east {
                currentRoom = room
            }
        case .south:
            if let room = currentRoom.south {
                currentRoom = room
            }
        case .west:
            if let room = currentRoom.west {
                currentRoom = room
            }
        }
        
    }
    init(){
        firstRoom.roomName = "first room"
        self.currentRoom = self.firstRoom
        addNewRoom(to: firstRoom, direction: .east)
        moveTo(direction: .east)
        assert(currentRoom === firstRoom.east!)
        currentRoom.roomName = "east1"
        addNewRoom(to: currentRoom, direction: .east)
        moveTo(direction: .east)
        currentRoom.roomName = "east2"
    }
}
struct ContentView: View {
    @StateObject var vm = RoomsVM()
    
    var body: some View {
        VStack{
            Text("\(vm.currentRoom.roomName)")
            VStack{
                Button {
                    vm.moveTo(direction: .north)
                } label: {
                    Text("North")
                }
                HStack{
                    Button {
                        vm.moveTo(direction: .west)
                    } label: {
                        Text("West")
                    }
                    Button {
                        vm.moveTo(direction: .east)
                    } label: {
                        Text("East")
                    }
                }
                Button {
                    vm.moveTo(direction: .south)
                } label: {
                    Text("South")
                }

            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
