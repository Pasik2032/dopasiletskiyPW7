//
//  NavigatorViewController+TextFieldDelegate.swift
//  dopasiletskiyPW7
//
//  Created by Даниил Пасилецкий on 30.01.2022.
//

import UIKit

extension NavigatorViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        let startText = startLocation.text?.replacingOccurrences(of: " ", with: "")
        let endText = endLocation.text?.replacingOccurrences(of: " ", with: "")
        if (startText != nil && startText != "") && (endText != nil && endText != "" ) && textField == endLocation {
            goButtonWasPressed()
        }
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        let startText = startLocation.text?.replacingOccurrences(of: " ", with: "")
        let endText = endLocation.text?.replacingOccurrences(of: " ", with: "")
        if (startText != nil && startText != "") || (endText != nil && endText != "" ) {
            buttonClear.isActive(true)
            if (startText != nil && startText != "") && (endText != nil && endText != "" ){
                buttonGo.isActive(true)
            } else {
                buttonGo.isActive(false)
            }
        } else {
            buttonClear.isActive(false)
            buttonGo.isActive(false)
        }
    }
}
