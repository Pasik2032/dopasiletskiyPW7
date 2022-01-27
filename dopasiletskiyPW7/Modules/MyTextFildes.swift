//
//  MyTextFildes.swift
//  dopasiletskiyPW7
//
//  Created by Даниил Пасилецкий on 27.01.2022.
//

import UIKit

class MyTextFildes: UITextField {
    init(_ text: String) {
        super.init(frame: .zero)
        self.backgroundColor = UIColor.lightGray
        self.textColor = UIColor.black
        self.placeholder = text
        self.layer.cornerRadius = 2
        self.clipsToBounds = false
        self.font = UIFont.systemFont(ofSize: 15)
        self.borderStyle = UITextField.BorderStyle.roundedRect
        self.autocorrectionType = UITextAutocorrectionType.yes
        self.keyboardType = UIKeyboardType.default
        self.returnKeyType = UIReturnKeyType.done
        self.clearButtonMode = UITextField.ViewMode.whileEditing
        self.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
