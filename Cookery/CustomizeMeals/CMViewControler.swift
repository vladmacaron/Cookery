import UIKit

class CMViewController: UIViewController {
 
 @IBOutlet weak var CaloriesValue: UILabel!
 @IBOutlet weak var ProteinValues: UILabel!
 @IBOutlet weak var CarbValue: UILabel!
 @IBOutlet weak var SliderCalories: UISlider!
 @IBOutlet weak var SliderProtein: UISlider!
 @IBOutlet weak var SliderCarbs: UISlider!
 @IBOutlet weak var SliderFats: UISlider!
 @IBOutlet weak var FatValue: UILabel!
 @IBOutlet weak var ButtonFindMeal: UIButton!
 @IBOutlet weak var ChangeTypeButton: UIButton!
 @IBOutlet weak var DishType: UILabel!
 @IBOutlet weak var DurationValue: UILabel!
 @IBOutlet weak var SliderDuration: UISlider!
 
 
 override func viewDidLoad() {
  DishType.text = "Main Dish"
  ButtonFindMeal.layer.cornerRadius = 20
  ButtonFindMeal.backgroundColor = .mainGreen
  ButtonFindMeal.titleLabel?.font = .primaryTitleFont
 }
 
 //
 //Change Labelvalues on Sliderchange
 //
 @IBAction func DurationChange(_ sender: Any) {
  DurationValue.text = Int(SliderDuration.value).description
 }
 @IBAction func CaloriesChange(_ sender: Any) {
  CaloriesValue.text = Int(SliderCalories.value).description
 
 }
 @IBAction func ProteinChange(_ sender: Any) {
    ProteinValues.text = Int(SliderProtein.value).description
 }
 @IBAction func CarbChange(_ sender: Any) {
  CarbValue.text = Int(SliderCarbs.value).description
 }
 @IBAction func FatChange(_ sender: Any) {
  FatValue.text = Int(SliderFats.value).description
 }
 
 //
 //Buttons
 //
 @IBAction func OnClickMealtypeButton(_ sender: Any) {
  let vc = storyboard?.instantiateViewController(identifier: "MealTypeViewController") as! MealTypeViewController
  vc.modalPresentationStyle = .fullScreen
  vc.completion  = { text in
      self.DishType.text = text
  }
  present(vc,animated: true)
 }
 @IBAction func onClickButton(_ sender: Any) {
 // DishType.text  // take this for the mealtype search (Api asky for "type")
 // DurationValue // take this for time that meal should max. take to cook
 // FatValue //  take this for the max. Fat value
 // CarbValue //  take this for the max. Carb value
 // ProteinValues //  take this for the max. Protein value
 // CaloriesValue //  take this for the max. Calories value

    let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "FindRecipiesController") as! FindRecipiesController
    vc.type = DishType.text!
    if CaloriesValue.text != "0" {
        vc.caloriesValue = CaloriesValue.text!
    }
    if ProteinValues.text != "0" {
        vc.proteinValue = ProteinValues.text!
    }
    if CarbValue.text != "0" {
        vc.carbValue = CarbValue.text!
    }
    if FatValue.text != "0" {
        vc.fatValue = FatValue.text!
    }
    if DurationValue.text != "5" {
        vc.durationValue = DurationValue.text!
    }
    navigationController?.pushViewController(vc, animated: true)
 }
 
 
}
