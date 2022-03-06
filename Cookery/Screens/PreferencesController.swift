//
//  File.swift
//  Cookery
//
//  Created by Vladislav Mazurov on 19.05.21.
//

import UIKit

class PreferencesController: UIViewController {

    @IBOutlet weak var modifyButtonLabel: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modifyButtonLabel.layer.cornerRadius = 10
        modifyButtonLabel.backgroundColor = .mainGreen
        modifyButtonLabel.titleLabel?.font = .primaryTitleFont
    }

    @IBAction func modifyButtonPressed(_ sender: Any) {
    }
}
