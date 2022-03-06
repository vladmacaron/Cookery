//
//  ChipsSelectorView.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 11.05.21.
//

import UIKit

protocol ChipRepresentable {
    var name: String { get }
}

protocol ChipsSelectorViewDelegate: AnyObject {
    func didToggleChip()
}

extension ChipsSelectorView: ChipsSelectorViewDelegate {
    func didToggleChip() {
        delegate?.didToggleChip()
    }
}

class ChipsSelectorView<T: ChipRepresentable & StorageMainainable>: UIView {
    let chips: [T]
    private let numberOfItemsInColumn = 3
    private let interItemsSpacing: CGFloat = 10
    private let chipHeight: CGFloat = 40
    private var chipViewsMap: [ChipView: T] = [:]
    private var chipViews: [ChipView] = []
    weak var delegate: ChipsSelectorViewDelegate?
    
    var numberOfRows: Int {
        return Int(ceil(Double(chips.count) / Double(numberOfItemsInColumn)))
    }
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(frame: .zero)
        stackView.alignment = .fill
        stackView.spacing = interItemsSpacing
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private var horizontalStackView: UIStackView {
        let stackView = UIStackView(frame: .zero)
        stackView.alignment = .fill
        stackView.spacing = interItemsSpacing
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        return stackView
    }
    
    init(chips: [T]) {
        self.chips = chips
        super.init(frame: .zero)
        chips.forEach { [weak self] chip in
            if let chipView = Bundle.main.loadNibNamed("ChipView",
                                                       owner: self,
                                                       options: [:])?.first as? ChipView {
                if StorageManager.shared.isItemContained(chip) {
                    chipView.currentState = .selected
                }
                self?.chipViewsMap[chipView] = chip
                chipView.delegate = self
                chipView.text = chip.name
                self?.chipViews.append(chipView)
            }
        }
        
        addSubview(verticalStackView)
        NSLayoutConstraint.activate([
            verticalStackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 0.0),
            verticalStackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: 0.0),
            verticalStackView.topAnchor.constraint(equalTo: topAnchor, constant: 0),
            verticalStackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0.0)
        ])
        
        var currentChipView = 0
        for _ in 0..<numberOfRows {
            let stackView = horizontalStackView
            stackView.translatesAutoresizingMaskIntoConstraints = false
            for j in currentChipView..<(currentChipView + numberOfItemsInColumn) {
                if j < chipViews.count {
                    let view = chipViews[j]
                    view.translatesAutoresizingMaskIntoConstraints = false
                    NSLayoutConstraint.activate([
                        view.heightAnchor.constraint(equalToConstant: chipHeight)
                    ])
                    stackView.addArrangedSubview(view)
                    
                } else {
                    stackView.addArrangedSubview(UIView())
                }
                currentChipView += 1
            }
            verticalStackView.addArrangedSubview(stackView)
            verticalStackView.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override var intrinsicContentSize: CGSize {
        var size = super.intrinsicContentSize
        size.height = CGFloat(numberOfRows) * (chipHeight + interItemsSpacing)
        return size
    }
    
    var selectedChips: [T] {
        chipViews.filter { $0.currentState == .selected }
            .compactMap { chipViewsMap[$0] }
    }
}
