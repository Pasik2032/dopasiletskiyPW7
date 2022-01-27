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
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
