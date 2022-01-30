//
//  ViewController.swift
//  dopasiletskiyPW7
//
//  Created by Даниил Пасилецкий on 26.01.2022.
//

import UIKit
import CoreLocation
import MapKit
import YandexMapsMobile

protocol NavigatorViewProtocol: class {
    
    func configureMap(point: YMKPoint, zoom: Int)
    func configureButtons()
    func configureTextFildes()
    func onRoutesReceived(_ routes: [YMKDrivingRoute])
    func onRoutesError(_ error: Error)
    func buildPath(requestPoints: [YMKRequestPoint], responseHandler: @escaping ([YMKDrivingRoute]?, Error?) -> Void)
}



class NavigatorViewController: UIViewController {
    
    var presenter: NavigatorPresenterProtocol!
    let configurator: NavigatorConfiguratorProtocol = NavigatorConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
    }
    
    private let yandexMap: YMKMapView = {
        let map = YMKMapView()
        return map
    }()
    
     let buttonGo: BigButton = {
        let control = BigButton(background: .systemGreen, text: "Go")
        control.addTarget(self, action: #selector(goButtonWasPressed), for: .touchUpInside)
        return control
    }()
    
   let buttonClear: BigButton = {
        let control = BigButton(background: .red, text: "Clear")
        control.addTarget(self, action: #selector(clearButtonWasPressed), for: .touchUpInside)
        return control
    }()
    

    
    let startLocation: MyTextFildes = MyTextFildes("From")
    
    let endLocation: MyTextFildes = MyTextFildes("To")
    
    var coordinates: [CLLocationCoordinate2D] = []
    
    var point: [NavigetorPoint] = []
    

    
    @objc func goButtonWasPressed(){

        guard
            let first = startLocation.text,
            let second = endLocation.text,
            first != second
        else {
            return
        }
        presenter.goButtonClicked(from: first, to: second)
    }
    
    var drivingSession: YMKDrivingSession?
    
    func buildPath(requestPoints: [YMKRequestPoint], responseHandler: @escaping ([YMKDrivingRoute]?, Error?) -> Void){

        let drivingRouter = YMKDirections.sharedInstance().createDrivingRouter()
        drivingSession = drivingRouter.requestRoutes(
            with: requestPoints,
            drivingOptions: YMKDrivingDrivingOptions(),
            vehicleOptions: YMKDrivingVehicleOptions(),
            routeHandler: responseHandler)
    }
    
    
    @objc func clearButtonWasPressed(){
        startLocation.text = nil
        endLocation.text = nil
        buttonGo.isActive(false)
        buttonClear.isActive(false)
        drivingSession?.cancel()
        let mapObjects = yandexMap.mapWindow.map.mapObjects
        mapObjects.clear()
    }
}



// MARK: ConfigureUI
extension NavigatorViewController: NavigatorViewProtocol{
    
    func configureMap(point: YMKPoint, zoom: Int) {
        view.addSubview(yandexMap)
        yandexMap.frame = view.frame
        yandexMap.mapWindow.map.move(
            with: YMKCameraPosition.init(target: point, zoom: Float(zoom), azimuth: 0, tilt: 0),
            animationType: YMKAnimation(type: YMKAnimationType.smooth, duration: 5),
            cameraCallback: nil)
    }
    
    func configureButtons() {
        let stack = UIStackView(arrangedSubviews: [buttonGo, buttonClear])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20
        yandexMap.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func configureTextFildes() {
        let textStack = UIStackView()
        textStack.axis = .vertical
        yandexMap.addSubview(textStack)
        textStack.spacing = 10
        textStack.pin(to: view, [.top: 50, .left: 10, .right: 10])
        [startLocation, endLocation].forEach { textField in
            textField.setHeight(to: 40)
            textField.delegate = self
            textStack.addArrangedSubview(textField)
        }
    }
    
    func onRoutesReceived(_ routes: [YMKDrivingRoute]) {
        let mapObjects = yandexMap.mapWindow.map.mapObjects
        for route in routes {
            mapObjects.addPolyline(with: route.geometry)
        }
    }
    
    func onRoutesError(_ error: Error) {
        let routingError = (error as NSError).userInfo[YRTUnderlyingErrorKey] as! YRTError
        var errorMessage = "Unknown error"
        if routingError.isKind(of: YRTNetworkError.self) {
            errorMessage = "Network error"
        } else if routingError.isKind(of: YRTRemoteError.self) {
            errorMessage = "Remote server error"
        }
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
    
}
