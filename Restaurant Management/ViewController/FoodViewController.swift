//
//  FoodViewController.swift
//  Restaurant Management
//
//  Created by Nahid Hasan Prodhan on 9/2/19.
//  Copyright © 2019 Riajur Rahman. All rights reserved.
//

import UIKit
import SwiftyJSON
import Kingfisher

class FoodViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    var shopId = 0
    var shopName = ""
    
    var foodList: [JSON] = [JSON]()
    var cart: [JSON] = [JSON]()
    var cartFood: [CartFood] = [CartFood]()
    
    let foodViewModel = FoodViewModel()
    
    let placeHolder = UIImage(named: "placeholder-image")
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = shopName
        
        self.view.setNeedsLayout()
        self.view.layoutIfNeeded()
        
        addBackBarButton()
        setupCustomCollectView()
        addNotificationObserver()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        doFetchFoods()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationItem.rightBarButtonItem = nil
    }
    
    @objc func goBack(_ sender: UIBarButtonItem){
        
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    @objc func cartButtonPressed(_ sender: UIBarButtonItem){
        
        if cart.count > 0 {
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let foodController = mainStoryboard.instantiateViewController(withIdentifier: "CartVC") as? CartViewController
            foodController?.cart = cart
            foodController?.foodCard = cartFood
            self.navigationController?.pushViewController(foodController!, animated: true)
        }
    }
    
    func addNotificationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(getCartData(notification:)), name: .cart, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func getCartData(notification: NSNotification) {
        
        if let data = notification.object as? [JSON] {
            print(data)
        }
    }
    
    func addBackBarButton(){
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        let backButton = UIBarButtonItem(image:UIImage(named:"ic_back"), style:.plain, target:self, action:#selector(FoodViewController.goBack(_:)))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
        
        let cartButton = UIBarButtonItem(image:UIImage(named:"ic_cart"), style:.plain, target:self, action:#selector(FoodViewController.cartButtonPressed(_:)))
        cartButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = cartButton
    }
    
    func setupCustomCollectView() {
        cart = [JSON]()
        cartFood = [CartFood]()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.backgroundColor = UIColor.clear
    }
    
    private func doFetchFoods() {
        SwiftOverlays.showTextOverlay(self.view, text: "Please wait...")
        
        if shopId != 0 {
            foodViewModel.fetchFoods(String(shopId))
            foodViewModel.showAlertClosure = {
                if let error = self.foodViewModel.error {
                    print(error.localizedDescription)
                }
            }
            
            foodViewModel.didFinishFetch = {
                do {
                    SwiftOverlays.removeAllBlockingOverlays()
                    self.foodList = [JSON]()
                    if let data = self.foodViewModel.foods {
                        for (_, object) in data {
                            self.foodList.append(object)
                        }
                        DispatchQueue.main.async {
                            self.collectionView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    @objc private func addButtonPressed(_ sender: UIButton) {
        
        if sender.tag < foodList.count {
            if let id = foodList[sender.tag]["id"].int {
                var itemCount = 0
                var itemId = id
                for i in 0..<cartFood.count {
                    let item = cartFood[i]
                    if item.id == id {
                        itemCount = item.count
                        itemId = id
                        break
                    }
                }
                showInputPopup(itemCount, itemIndex: sender.tag, itemId: itemId)
            }
        }
    }
    
    func showInputPopup(_ itemCount: Int, itemIndex: Int, itemId: Int) {
        
        let alertController = UIAlertController(title: "Confirmation", message: "How many item do you want to add ?", preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Item Count"
            textField.text = String(itemCount)
        }
        let confirmAction = UIAlertAction(title: "OK", style: .default) { [weak alertController] _ in
            guard let alertController = alertController, let textField = alertController.textFields?.first else { return }
            if itemIndex < self.foodList.count {
                self.cart.append(self.foodList[itemIndex])
                if let inp = textField.text {
                    let count = Int(inp)
                    print(count!)
                    let food = CartFood(id: itemId, count: count!)
                    self.cartFood.append(food)
                }
            }
        }
        alertController.addAction(confirmAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}


extension FoodViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: - UICollectionViewDataSource
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return foodList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath as IndexPath) as! FoodInfoCell
        
        if foodList.count > 0 {
            if let image = foodList[indexPath.row]["image"].string {
                let urlwithPercentEscapes = image.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
                cell.foodImage.kf.indicatorType = .activity
                cell.foodImage.kf.setImage(with: URL(string: urlwithPercentEscapes!), placeholder: placeHolder)
            }
            else {
                cell.foodImage.image = placeHolder
            }
            
            if let name = foodList[indexPath.row]["item_name"].string {
                cell.foodName.text = name
            }
            
            if let price = foodList[indexPath.row]["price"].string {
                cell.price.text = price
            }
            else if let price = foodList[indexPath.row]["price"].double {
                cell.price.text = String(price)
            }
            else if let price = foodList[indexPath.row]["price"].int {
                cell.price.text = String(price)
            }
            cell.itemAddButton.setImage(UIImage(named: "ic_add"), for: .normal)
            cell.itemAddButton.tag = indexPath.row
            cell.itemAddButton.tintColor = .green
            cell.itemAddButton.addTarget(self, action: #selector(FoodViewController.addButtonPressed(_:)), for: .touchUpInside)
        }
        return cell
    }
    
    // MARK: - UICollectionViewFlowLayout
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.size.width / 2.5
        let height = self.view.frame.size.height / 3
        return  CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        
        if Commons.selectedDevice() == Constants.IPHONE_6_PLUS_SIZES {
            let leftRightInset = self.view.frame.size.width / 15.0
            return UIEdgeInsetsMake(20, leftRightInset, 20, leftRightInset)
        }
        else{
            let leftRightInset = self.view.frame.size.width / 13.0
            return UIEdgeInsetsMake(20, leftRightInset, 20, leftRightInset)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
}





