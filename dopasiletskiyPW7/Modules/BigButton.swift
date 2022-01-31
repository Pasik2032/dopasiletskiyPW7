//
//  BigButton.swift
//  dopasiletskiyPW7
//
//  Created by Даниил Пасилецкий on 27.01.2022.
//

import UIKit

class BigButton: UIButton {
    init(background: UIColor, text: String, frame: CGRect = .zero) {
        super.init(frame: frame)
        setTitle(text, for: .normal)
        self.backgroundColor = background
        self.layer.cornerRadius = 10
        isActive(false)
    }
    
    func isActive(_ status: Bool){
        if status{
            setTitleColor(.white, for: .normal)
            isEnabled = true
        }else{
            setTitleColor(.gray, for: .disabled)
            isEnabled = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
