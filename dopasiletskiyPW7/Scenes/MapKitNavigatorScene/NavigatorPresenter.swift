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
    func rout(requestPoints : [YMKRequestPoint], point: YMKPoint)
    func goButtonClicked(from: String, to: String)
}

class NavigatorPresenter : NavigatorPresenterProtocol{
    
    func rout(requestPoints: [YMKRequestPoint], point: YMKPoint) {
        let responseHandler = {(routesResponse: [YMKDrivingRoute]?, error: Error?) -> Void in
            if let routes = routesResponse {
                self.view.onRoutesReceived(routes)
            } else {
                self.view.onRoutesError(error!)
            }
        }
        view.buildPath(requestPoints: requestPoints, responseHandler: responseHandler)
        
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
    }
    
    func cleanButtonClicked() {
        print("clean")
    }
    
    func goButtonClicked(from: String, to: String) {
        print("go")
        interactor.buildRoute(from: from, to: to)
        
    }
    
    
}
