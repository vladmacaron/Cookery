//
//  MyIngredientsViewController.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 21.05.21.
//

import UIKit

class MyIngredientsViewController: UIViewController {
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var addButtonView: UIView!
    @IBOutlet weak var addButton: DottedRoundedButton!
    
    private var storageManager = StorageManager.shared
    
    var model: [Ingredient] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        
        tableView.tableFooterView = addButtonView
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        model = storageManager.getAllItems()
        tableView.reloadData()
    }
    
    
    private func configureUI() {
        titleLabel.font = .primaryTitleFont
        titleLabel.textColor = .primaryTitleText
        titleLabel.text = "My ingredients"
        addButton.setTitle("Add ingredient", for: .normal)
    }

    @IBAction func addButtonAction(_ sender: Any) {
        let findIngredientsViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "AddIngredientsViewController")
        navigationController?.pushViewController(findIngredientsViewController, animated: true)
    }
    
    @objc func deleteButton(_ sender: UIButton) {
        tableView.beginUpdates()
        let index = sender.tag
        tableView.deleteRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
        storageManager.removedStoredItem(model[index])
        model.remove(at: index)
        tableView.endUpdates()
    }
}

extension MyIngredientsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        model.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath) as? ListTableViewCell else {
            return UITableViewCell()
        }
        let item = model[indexPath.row]
        cell.titleLabel.text = item.displayedName
        NetwokringHandler.loadImageURL(item.imageURL(for: .small), into: cell.itemImageView)
        cell.deleteButton.tag = indexPath.row
        cell.selectionStyle = .none
        cell.deleteButton.addTarget(self,
                                    action: #selector(deleteButton),
                                    for: .touchUpInside)
        return cell
    }
}
