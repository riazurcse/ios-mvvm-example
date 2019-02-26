//
//  CartViewController.swift
//  Restaurant Management
//
//  Created by Nahid Hasan Prodhan on 9/2/19.
//  Copyright © 2019 Riajur Rahman. All rights reserved.
//

import UIKit
import SwiftyJSON

class CartViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var cart: [JSON] = [JSON]()
    var foodCard: [CartFood] = [CartFood]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(cart)
        print(foodCard)
        
        addBackBarButton()
    }
    
    @objc func goBack(_ sender: UIBarButtonItem){
        
        NotificationCenter.default.post(name: .cart, object: cart)
        _ = self.navigationController?.popViewController(animated: true)
    }
    
    func addBackBarButton(){
        
        self.navigationItem.setHidesBackButton(true, animated: false)
        let backButton = UIBarButtonItem(image:UIImage(named:"ic_back"), style:.plain, target:self, action:#selector(FoodViewController.goBack(_:)))
        backButton.tintColor = .black
        self.navigationItem.leftBarButtonItem = backButton
    }
    
    func initCustomTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let xib = UINib(nibName: "ShopInfoCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "Cell")
    }
}


extension CartViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cart.count > 0 {
            return cart.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if cart.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopInfoCell
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}
