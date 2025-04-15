//
//  RoutesUseCasesProtocol.swift
//  CyBus
//
//  Created by Vadim Popov on 26/08/2024.
//

import Foundation

protocol StaticFilesUseCasesProtocol {
    var routes: [RouteDTO] { get }
    
    var shapes: [ShapeDTO] { get }
    
    var stopTimes: [StopTimeDTO] { get }
    
    var stops: [StopDTO] { get }
    
    var trips: [TripDTO] { get }
    
    func fetch() async throws

}
