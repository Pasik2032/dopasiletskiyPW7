//
//  ViewController.swift
//  dopasiletskiyPW7
//
//  Created by Даниил Пасилецкий on 26.01.2022.
//

import UIKit
import CoreLocation
import MapKit

class NavigatorViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        print("main")
        // Do any additional setup after loading the view.
    }
    
    private let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.layer.masksToBounds = true
        mapView.layer.cornerRadius = 5
        mapView.clipsToBounds = false
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.showsScale = true
        mapView.showsCompass = true
        mapView.showsTraffic = true
        mapView.showsBuildings = true
        mapView.showsUserLocation = true
        return mapView
    }()
    
    private let buttonGo: BigButton = BigButton(background: .systemGreen, text: "Go")
    
    private let buttonClear: BigButton = BigButton(background: .red, text: "Clear")
    
    private let stack: UIStackView = {
        let stack = UIStackView()
        return stack
    }()
    
    let startLocation: MyTextFildes = MyTextFildes("From")
    
    let endLocation: MyTextFildes = MyTextFildes("To")
    
    
    private func configureUI() {
        view.addSubview(mapView)
        mapView.frame = view.frame
        let stack = UIStackView(arrangedSubviews: [buttonGo, buttonClear])
        stack.axis = .horizontal
        stack.distribution = .fillEqually
        stack.spacing = 20
        view.addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        stack.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        let textStack = UIStackView()
        textStack.axis = .vertical
        view.addSubview(textStack)
        textStack.spacing = 10
        textStack.pin(to: view, [.top: 50, .left: 10, .right: 10])
        [startLocation, endLocation].forEach { textField in
            textField.setHeight(to: 40)
            textField.delegate = self
            textStack.addArrangedSubview(textField)
        }
    }
}

extension NavigatorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
