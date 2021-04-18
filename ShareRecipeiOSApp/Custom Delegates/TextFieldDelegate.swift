//
//  TextFieldDelegate.swift
//  ShareRecipeiOSApp
//
//  Created by Cameron Augustine on 3/21/21.
//

import Foundation
import UIKit

class TextFieldDelegate: NSObject, UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
