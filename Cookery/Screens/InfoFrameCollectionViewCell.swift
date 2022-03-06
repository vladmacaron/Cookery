//
//  InfoFrameCollectionViewCell.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 21.05.21.
//

import UIKit

class InfoFrameCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var label: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        label.textColor = .descriptiontText
        label.font = .applicationRegularFont(withSize: 12)
        
        clipsToBounds = true
        layer.cornerRadius = 10
        layer.borderWidth = 1
        layer.borderColor = UIColor.paleGrey?.cgColor
        translatesAutoresizingMaskIntoConstraints = false
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.image = nil
    }
 //color change for cell
 func changetodefaultcolor() {
    layer.borderColor = UIColor.paleGrey?.cgColor
 }
 
 func changecolor() {
   layer.borderColor = UIColor.mainGreen?.cgColor
 }
     

}
