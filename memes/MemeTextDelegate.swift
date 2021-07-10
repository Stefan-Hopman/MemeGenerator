//
//  MemeTextDelegate.swift
//  memes
//
//  Created by Stefan Hopman on 6/26/21.
//

import UIKit

class MemeTextDelegate: NSObject, UITextFieldDelegate {
    
    //MARK: Text Properties
    let memeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor: UIColor.black,                                    //outline color of the text
        NSAttributedString.Key.foregroundColor: UIColor.white,                                //main text color of the font
        NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!, //font size and height
        NSAttributedString.Key.strokeWidth: -3.0                                               //size of the outline
    ]
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text == "top" || textField.text == "bottom" {
        textField.text = ""
            print("clearing text")
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        var newText = textField.text! as NSString
        newText = newText.replacingCharacters(in: range, with: string) as NSString
        return true
    }
    
    func applyStyleToText(for field: UITextField, Defaulttext: String) {
        field.textAlignment = .center
        field.defaultTextAttributes = memeTextAttributes
        field.backgroundColor = .clear
        field.borderStyle = .none
        field.textAlignment = .center
        field.autocapitalizationType = .allCharacters
        field.text = Defaulttext
        print("applied text called")
    }
}
