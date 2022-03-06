//
//  MainContainmentViewController.swift
//  Cookery
//
//  Created by Rosi-Eliz Dzhurkova on 17.05.21.
//

import UIKit

class MainContainmentViewController: UIViewController {

    @IBOutlet private weak var containerView: UIView!
    @IBOutlet weak var tabContainerView: UIView!
    @IBOutlet weak var buttonsContainer: UIView!
    
    @IBOutlet weak var firstTab: UIButton!
    @IBOutlet weak var secondTab: UIButton!
    @IBOutlet weak var thirdTab: UIButton!
    @IBOutlet weak var fourthTab: UIButton!
    
    
    private lazy var containedViewControllers: [UIViewController] = {
        var viewControllers: [UIViewController] = []
        viewControllers.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "DashboardViewController"))
        viewControllers.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "MyIngredientsViewController"))
        viewControllers.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "SavedRecipiesController"))
        viewControllers.append(UIStoryboard(name: "Main", bundle: nil).instantiateViewController(identifier: "IntolerancesViewController"))
        
        return viewControllers
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstTabAction(self)

        buttonsContainer.layer.shadowColor = UIColor.lightGray.cgColor
        buttonsContainer.layer.shadowOpacity = 0.3
        buttonsContainer.layer.shadowOffset = CGSize(width: 0, height: -5)
        buttonsContainer.layer.shadowRadius = 5
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.toolbar.setShadowImage(UIImage(), forToolbarPosition: .any)
        navigationController?.navigationBar.barTintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.mainGreen]
    }

    
    // MARK: - Tabs Navigation
    @IBAction func firstTabAction(_ sender: Any) {
        add(containedViewControllers[0])
        setActiveTab(0)
        navigationItem.titleView = UIImageView(image: UIImage(named: "textLogo"))
    }
    
    @IBAction func secondTabAction(_ sender: Any) {
        add(containedViewControllers[1])
        setActiveTab(1)
        navigationItem.title = "Ingredients".uppercased()
        navigationItem.titleView = nil
    }
    
    @IBAction func thirdTabAction(_ sender: Any) {
        add(containedViewControllers[2])
        setActiveTab(2)
        navigationItem.title = "Bookmarks".uppercased()
        navigationItem.titleView = nil
    }
    
    @IBAction func fourthTabAction(_ sender: Any) {
        add(containedViewControllers[3])
        setActiveTab(3)
        navigationItem.title = "Intolerances".uppercased()
        navigationItem.titleView = nil
    }
    
    private func setActiveTab(_ index: Int) {
        switch index {
        case 0:
            firstTab.alpha = 1
            firstTab.isUserInteractionEnabled = false
            secondTab.alpha = 0.5
            secondTab.isUserInteractionEnabled = true
            thirdTab.alpha = 0.5
            thirdTab.isUserInteractionEnabled = true
            fourthTab.alpha = 0.5
            fourthTab.isUserInteractionEnabled = true
        case 1:
            firstTab.alpha = 0.5
            firstTab.isUserInteractionEnabled = true
            secondTab.alpha = 1
            secondTab.isUserInteractionEnabled = false
            thirdTab.alpha = 0.5
            thirdTab.isUserInteractionEnabled = true
            fourthTab.alpha = 0.5
            fourthTab.isUserInteractionEnabled = true
            
        case 2:
            firstTab.alpha = 0.5
            firstTab.isUserInteractionEnabled = true
            secondTab.alpha = 0.5
            secondTab.isUserInteractionEnabled = true
            thirdTab.alpha = 1
            thirdTab.isUserInteractionEnabled = false
            fourthTab.alpha = 0.5
            fourthTab.isUserInteractionEnabled = true
            
        case 3:
            firstTab.alpha = 0.5
            firstTab.isUserInteractionEnabled = true
            secondTab.alpha = 0.5
            secondTab.isUserInteractionEnabled = true
            thirdTab.alpha = 0.5
            thirdTab.isUserInteractionEnabled = true
            fourthTab.alpha = 1
            fourthTab.isUserInteractionEnabled = false
            
        default:
            fatalError("Incorrect index")
        }
    }
}

private extension MainContainmentViewController {
    func add(_ child: UIViewController) {
        addChild(child)
        
        containerView.addSubview(child.view)
        child.view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            child.view.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 0.0),
            child.view.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: 0.0),
            child.view.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 0.0),
            child.view.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: 0.0)
        ])
        child.didMove(toParent: self)
    }

    func remove() {
        willMove(toParent: nil)
        containerView.subviews.forEach { $0.removeFromSuperview() }
        removeFromParent()
    }
}
