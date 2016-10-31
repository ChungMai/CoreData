//
//  GenericVC.swift
//  Groceries
//
//  Created by Tim Roadley on 29/09/2015.
//  Copyright © 2015 Tim Roadley. All rights reserved.
//

import UIKit

class GenericVC: UIViewController {
    
    func hideKeyboard () {
        self.view.endEditing(true)
    }
    
   func hideKeyboardWhenBackgroundIsTapped () {
        let tgr = UITapGestureRecognizer(target: self, action:Selector("hideKeyboard"))
        self.view.addGestureRecognizer(tgr)
   }
}
