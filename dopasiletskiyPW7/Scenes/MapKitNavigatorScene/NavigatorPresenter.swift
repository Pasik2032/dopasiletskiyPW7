//
//  NavigatorPresenter.swift
//  dopasiletskiyPW7
//
//  Created by Даниил Пасилецкий on 28.01.2022.
//

import Foundation
import YandexMapsMobile

protocol NavigatorPresenterProtocol: class {
//    var router: NavigatorRouterProtocol! { set get }
    func configureView()
    func cleanButtonClicked()
    func rout(requestPoints : [YMKRequestPoint], point: YMKPoint, type: Int)
    func goButtonClicked(from: String, to: String, type: Int)
}

class NavigatorPresenter : NavigatorPresenterProtocol{
    
    func rout(requestPoints: [YMKRequestPoint], point: YMKPoint, type: Int) {
        
//        var responseHandler: ([YMKDrivingRoute]?, Error?) -> Void
//        var responseHandlerForPedestrian: ([YMKMasstransitRoute]?, Error?) -> Void
        
        switch type {
        case 0:
            let responseHandler = {(routesResponse: [YMKDrivingRoute]?, error: Error?) -> Void in
                if let routes = routesResponse {
                    self.view.onRoutesReceived(routes)
                } else {
                    self.view.onRoutesError(error!)
                }
            }
            view.buildPath(requestPoints: requestPoints, responseHandler: responseHandler)
        case 1...3:
            let responseHandlerForPedestrian = {(routesResponse: [YMKMasstransitRoute]?, error: Error?) -> Void in
                if let routes = routesResponse {
                    self.view.onRoutesForPedestrianReceived(routes)
                } else {
                    self.view.onRoutesError(error!)
                }
            }
            view.buildRoutePedestrian(requestPoints: requestPoints, type: type, responseHandlerForPedestrian: responseHandlerForPedestrian)
        default: print("Error")
        }
        
        
        
        
        view.configureMap(point: point, zoom: 5)
        
    }
    
    
    weak var view: NavigatorViewProtocol!
    var interactor: NavigatorInteractorProtocol!
    
    required init(view: NavigatorViewProtocol) {
           self.view = view
    }
    
    func configureView() {
        //TODO: сделать стартовое положение
        view.configureMap(point: YMKPoint(latitude: 55.751574, longitude: 37.573856), zoom: 15)
        view.configureButtons()
        view.configureTextFildes()
        view.configureSegment()
        view.configureText()
    }
    
    func cleanButtonClicked() {
        print("clean")
    }
    
    func goButtonClicked(from: String, to: String, type: Int) {
        print("go")
        interactor.buildRoute(from: from, to: to, type: type)
        
    }
    
    
}
