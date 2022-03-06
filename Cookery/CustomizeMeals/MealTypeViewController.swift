//
//  MealTypeViewController.swift
//  Cookery
//
//  Created by Lukas Pezzei on 19.05.21.
//

import SwiftUI


struct MealType: ChipRepresentable {
    var name: String
}

class MealTypeViewController: UIViewController  , UITableViewDelegate, UITableViewDataSource {
 @IBOutlet weak var Table: UITableView!
 @IBOutlet weak var BackButton: UIButton!
 
 public var completion: ((String?) -> Void)?
 var MealTypes = [ "main course","side dish", "dessert", "appetizer",
                   "salad", "bread", "breakfast","soup", "beverage",
                   "sauce", "marinade", "fingerfood","snack", "drink"]

 override func viewDidLoad() {
  Table.dataSource = self
  Table.delegate = self
 }
 //
 //Table
 //
 func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
  completion?(MealTypes[indexPath.row].description)
  self.dismiss(animated: true, completion: nil)
 }
 
 func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
  return MealTypes.count
 }
 func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
  let cell = tableView.dequeueReusableCell(withIdentifier: "MyCell", for: indexPath)
  cell.textLabel!.text = MealTypes[indexPath.row]
  return cell
 }
 
 //
 //Button
 //
 @IBAction func OnClickBackButton(_ sender: Any) {
  self.dismiss(animated: true, completion: nil)
 }
 
 
}
 
