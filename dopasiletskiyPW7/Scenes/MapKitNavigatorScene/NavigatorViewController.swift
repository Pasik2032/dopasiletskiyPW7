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
    func configureSegment()
    func configureText()
    func onRoutesReceived(_ routes: [YMKDrivingRoute])
    func onRoutesError(_ error: Error)
    func buildPath(requestPoints: [YMKRequestPoint], responseHandler: @escaping ([YMKDrivingRoute]?, Error?) -> Void)
    func buildRoutePedestrian(requestPoints: [YMKRequestPoint], type: Int, responseHandlerForPedestrian: @escaping ([YMKMasstransitRoute]?, Error?) -> Void)
    func onRoutesForPedestrianReceived(_ routes: [YMKMasstransitRoute])
    
}



class NavigatorViewController: UIViewController {
    
    var presenter: NavigatorPresenterProtocol!
    let configurator: NavigatorConfiguratorProtocol = NavigatorConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configurator.configure(with: self)
        presenter.configureView()
    }
    
    var length = 0.0
    
    private let yandexMap: YMKMapView = {
        let map = YMKMapView()
        return map
    }()
    
    private let text: UITextView = {
        let control = UITextView()
        control.backgroundColor = .white
        control.text = ""
        control.translatesAutoresizingMaskIntoConstraints = false
        return control
    }()
    
    private let segment: UISegmentedControl = {
        let control = UISegmentedControl(items: ["машина", "пешком", "велосипед", "общественный транспорт"])
        control.selectedSegmentIndex = 0;
        return control
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
    
    let textStack = UIStackView()
    
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
        
        presenter.goButtonClicked(from: first, to: second, type: segment.selectedSegmentIndex)
    }
    
    var drivingSession: YMKDrivingSession?
    
    var drivingSessionForPedestrian : YMKMasstransitSession?
    
    var drivingSessionForBicycle : YMKBicycleSession?
    
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
    
    func configureText(){
        yandexMap.addSubview(text)
        text.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        text.topAnchor.constraint(equalTo: segment.bottomAnchor, constant: 10).isActive = true
        text.heightAnchor.constraint(equalToConstant: 20).isActive = true
        text.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
    }
    
    func configureTextFildes() {
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
    func configureSegment() {
        yandexMap.addSubview(segment)
        segment.translatesAutoresizingMaskIntoConstraints = false
        segment.topAnchor.constraint(equalTo: textStack.bottomAnchor, constant: 10).isActive = true
        segment.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 10).isActive = true
        segment.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -10).isActive = true
        segment.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    
    func onRoutesReceived(_ routes: [YMKDrivingRoute]) {
        let mapObjects = yandexMap.mapWindow.map.mapObjects
        text.text = String(Double(routes[0].geometry.points.count) * 0.0415)
        mapObjects.addPolyline(with: routes[0].geometry)
    }

    
    func onRoutesForBicycleReceived(_ routes: [YMKBicycleRoute]) {
            let mapObjects = yandexMap.mapWindow.map.mapObjects

        text.text = String(Double(routes[0].geometry.points.count) * 0.0415)
                mapObjects.addPolyline(with: routes[0].geometry)
           
        }
    
    func onRoutesForPedestrianReceived(_ routes: [YMKMasstransitRoute]) {
            let mapObjects = yandexMap.mapWindow.map.mapObjects
                text.text = String(Double(routes[0].geometry.points.count) * 0.0415)
                mapObjects.addPolyline(with: routes[0].geometry)
           
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
    
    func buildRoutePedestrian(requestPoints: [YMKRequestPoint], type: Int, responseHandlerForPedestrian: @escaping ([YMKMasstransitRoute]?, Error?) -> Void) {
        
//        var pedestrianRouter : YMKMasstransitSessionRouteHandler
        let pedestrianRouter = YMKTransport.sharedInstance().createPedestrianRouter()
        let bicycleRouter = YMKTransport.sharedInstance().createBicycleRouter()
        let masstransitRouter = YMKTransport.sharedInstance().createMasstransitRouter()

        switch type{
        case 1:
            drivingSessionForPedestrian = pedestrianRouter.requestRoutes(
                with: requestPoints,
                timeOptions: YMKTimeOptions(),
                routeHandler: responseHandlerForPedestrian
            )
        case 2:
            drivingSessionForBicycle = bicycleRouter.requestRoutes(
                with: requestPoints,
                routeListener: { routesResponse, error in
                    if let routes = routesResponse {
                        self.onRoutesForBicycleReceived(routes)
                    } else {
                        self.onRoutesError(error!)
                    }
                })
            
        case 3:
            drivingSessionForPedestrian = masstransitRouter.requestRoutes(
                with: requestPoints,
                masstransitOptions: YMKMasstransitOptions.init(),
                routeHandler: responseHandlerForPedestrian)
        default:
            drivingSessionForPedestrian = pedestrianRouter.requestRoutes(
                with: requestPoints,
                timeOptions: YMKTimeOptions(),
                routeHandler: responseHandlerForPedestrian
            )
        }
    }
    
}
