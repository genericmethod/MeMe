//
//  MemeTextFieldDelegate.swift
//  meme
//
//  Created by Chris Farrugia on 07/05/2016.
//  Copyright © 2016 Chris Farrugia. All rights reserved.
//

import Foundation
import UIKit

class MemeTextFieldDelegate : NSObject, UITextFieldDelegate {
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
}

