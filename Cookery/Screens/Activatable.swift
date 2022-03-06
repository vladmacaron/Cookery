//
//  Activatable.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 21.05.21.
//

import UIKit

protocol Activatable: UIViewController {
    var spinnerHolder: UIView? { get set }
}

extension Activatable {
    func startActivity() {
        spinnerHolder = UIView(frame: view.bounds)
        spinnerHolder?.backgroundColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = spinnerHolder?.center ?? .zero
        activityIndicator.startAnimating()
        spinnerHolder?.addSubview(activityIndicator)
        if let spinnerHolder = spinnerHolder {
            if let navigationController = navigationController {
                navigationController.view.addSubview(spinnerHolder)
                spinnerHolder.frame = navigationController.view.bounds
            } else {
                view.addSubview(spinnerHolder)
            }
        }
    }
    
    func stopActivity() {
        spinnerHolder?.removeFromSuperview()
        spinnerHolder = nil
    }
}
