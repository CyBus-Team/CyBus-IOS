//
//  SelectedBusGroup.swift
//  CyBus
//
//  Created by Vadim Popov on 26/12/2024.
//

struct SelectedBusGroupState: Equatable {
    let group : BusGroupEntity
    let index : Int
    let bus: BusEntity
    
    static func defaultValue(group: BusGroupEntity) -> SelectedBusGroupState {
        SelectedBusGroupState(group: group, index: 0, bus: group.buses.first!)
    }
}
