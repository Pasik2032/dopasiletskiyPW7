//
//  NavigatorInteractor.swift
//  dopasiletskiyPW7
//
//  Created by Даниил Пасилецкий on 30.01.2022.
//

import Foundation
import YandexMapsMobile
import CoreLocation

protocol NavigatorInteractorProtocol: class {
    func buildRoute(from: String, to: String)
}

class NavigatorInteractor: NavigatorInteractorProtocol{

    func buildRoute(from: String, to: String) {
        var requestPoints : [YMKRequestPoint] = []
        let group = DispatchGroup()
        group.enter()
        var startpoint: YMKPoint?
        var endpoint: YMKPoint?
        getCoordinateFrom(address: from, completion: { [weak self] coords,_ in
            if let coords = coords {

                requestPoints.append(YMKRequestPoint(point: YMKPoint(latitude: coords.latitude, longitude: coords.longitude), type: .waypoint, pointContext: nil))
                startpoint = YMKPoint(latitude: coords.latitude, longitude: coords.longitude)

            }
            group.leave()
        })
        
        group.enter()
        getCoordinateFrom(address: to, completion: { [weak self] coords,_ in
            if let coords = coords {
                endpoint =  YMKPoint(latitude: coords.latitude, longitude: coords.longitude)
                requestPoints.append(YMKRequestPoint(point: YMKPoint(latitude: coords.latitude, longitude: coords.longitude), type: .waypoint, pointContext: nil))
            }
            group.leave()
        })
      
       
        group.notify(queue: .main) {
            DispatchQueue.main.async { [weak self] in
                let midPoint = YMKPoint(latitude: (startpoint!.latitude + endpoint!.latitude)/2, longitude: (startpoint!.longitude + endpoint!.longitude)/2)
                self?.presenter.rout(requestPoints: requestPoints, point: midPoint)
            }
        }
            
    }
    
    private func getCoordinateFrom(address: String, completion:
                                   @escaping(_ coordinate: CLLocationCoordinate2D?, _ error: Error?)
                                   -> () ) {
        DispatchQueue.global(qos: .background).async {
            CLGeocoder().geocodeAddressString(address)
            { completion($0?.first?.location?.coordinate, $1) }
        }
    }
    
    
    
    weak var presenter: NavigatorPresenterProtocol!
    
    required init(presenter: NavigatorPresenterProtocol) {
            self.presenter = presenter
        }
        
}
