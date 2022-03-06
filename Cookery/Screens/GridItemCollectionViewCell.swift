//
//  GridItemCollectionViewCell.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 20.05.21.
//

import UIKit

class GridItemCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var gridImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configureUI()
    }
    
    private func configureUI() {
        gridImageView.layer.cornerRadius = 10
        gridImageView.clipsToBounds = true
        
        titleLabel.textColor = .white
        titleLabel.font = .applicationRegularFont(withSize: 10)
        
        subtitleLabel.textColor = .white
        subtitleLabel.font = .secondaryTitleFont
        gridImageView.backgroundColor = .mainGreen
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.gridImageView.image = nil
    }
}
