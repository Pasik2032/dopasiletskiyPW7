//
//  NavigatorConfigurator.swift
//  dopasiletskiyPW7
//
//  Created by Даниил Пасилецкий on 28.01.2022.
//

import Foundation

protocol NavigatorConfiguratorProtocol: class {
    func configure(with viewController: NavigatorViewController)
}

class NavigatorConfigurator : NavigatorConfiguratorProtocol {
    func configure(with viewController: NavigatorViewController) {
        let presenter = NavigatorPresenter(view: viewController)
        let interactor = NavigatorInteractor(presenter: presenter)
        
        viewController.presenter = presenter
        presenter.interactor = interactor
        //presenter.currencyPickerView = viewController.currencyPickerView
        //viewController.currencyPickerView.delegate = presenter
    }
    
    
}
