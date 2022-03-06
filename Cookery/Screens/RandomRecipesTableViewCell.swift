//
//  RandomRecipesTableViewCell.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 20.05.21.
//

import UIKit

protocol RandomRecipesDelegate: AnyObject {
    func didSelectItem(_ item: Recipes)
}

class RandomRecipesTableViewCell: UITableViewCell {
    @IBOutlet private weak var collectionView: UICollectionView!
    
    weak var delegate: RandomRecipesDelegate?
    private let interItemsSize: CGFloat = 20
    private let itemSize = CGSize(width: 290, height: 180)
    private var model: [Recipes] = [] {
        didSet {
            collectionView.reloadData()
        }
    }
    
    func configure(with model: [Recipes]) {
        let width = CGFloat(itemSize.width + interItemsSize) * CGFloat(model.count)
        let height = itemSize.height
        collectionView.contentSize = CGSize(width: width, height: height)
        collectionView.showsHorizontalScrollIndicator = false
        self.model = model
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.contentInset = UIEdgeInsets(top: 0, left: interItemsSize, bottom: 0, right: 0)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "GridItemCollectionViewCell", bundle: nil),
                                forCellWithReuseIdentifier: "Cell")
        (collectionView.collectionViewLayout as? UICollectionViewFlowLayout)?.itemSize = itemSize
    }
}

extension RandomRecipesTableViewCell: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as? GridItemCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let item = model[indexPath.row]
        NetwokringHandler.loadImageURL(item.image, into: cell.gridImageView)
        cell.titleLabel.text = item.dishTypes.first?.uppercased() ?? "MEAL"
        cell.subtitleLabel.text = item.title
        
        return cell
    }
}

extension RandomRecipesTableViewCell: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didSelectItem(model[indexPath.row])
    }
}
