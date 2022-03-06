//
//  ChipView.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 11.05.21.
//

import UIKit

class ChipView: UIView {
    enum State {
        case selected
        case notSelected
        
        mutating func toggle() {
            switch self {
            case .selected:
                self = .notSelected
            case .notSelected:
                self = .selected
            }
        }
    }
    
    weak var delegate: ChipsSelectorViewDelegate?
    @IBOutlet weak var label: UILabel!
    private var tapGestureRecognizer: UITapGestureRecognizer?
    var currentState: State = .notSelected {
        didSet {
            configureUI(for: currentState)
        }
    }
    var text: String = "" {
        didSet {
            configureUI(for: currentState)
        }
    }
    private let selectedColor = UIColor.mainGreen
    private let borderColor = UIColor.descriptiontText
    private let selectedTextColor = UIColor.white
    private let nonSelectedTextColor = UIColor.descriptiontText
 
    override func awakeFromNib() {
        super.awakeFromNib()
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(didTapAction))
        if let tapGestureRecognizer = tapGestureRecognizer {
            addGestureRecognizer(tapGestureRecognizer)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = frame.height / 2
        configureUI(for: currentState)
    }
    
    @objc func didTapAction(sender: Any?) {
        currentState.toggle()
        delegate?.didToggleChip()
    }
    
    private func configureUI(for state: State) {
        switch state {
        case .selected:
            backgroundColor = selectedColor
            label.textColor = selectedTextColor
            layer.borderWidth = 0
        case .notSelected:
            backgroundColor = .clear
            label.textColor = nonSelectedTextColor
            layer.borderWidth = 1
            layer.borderColor = nonSelectedTextColor?.cgColor
            break
        }
        
        label.text = text
    }
}
