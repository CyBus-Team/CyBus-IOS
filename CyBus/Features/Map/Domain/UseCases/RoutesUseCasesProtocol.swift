//
//  RoutesUseCasesProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 03/04/2025.
//

import Foundation

protocol RoutesUseCasesProtocol {
    
    func getRoute(for routeID: String) -> RouteEntity
    
}
