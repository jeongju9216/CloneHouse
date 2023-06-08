//
//  UIViewController.swift
//  CloneHouse
//
//  Created by 유정주 on 2023/06/06.
//

import UIKit

extension UIViewController {
    static var storyboardName: String {
        String(describing: self)
    }
    
    static var storyboard: UIStoryboard {
        UIStoryboard(name: storyboardName, bundle: nil)
    }
    
    static var instantiate: UIViewController {
        storyboard.instantiateViewController(withIdentifier: storyboardName)
    }
}
