//
//  FoodShopViewController.swift
//  Restaurant Management
//
//  Created by Nahid Hasan Prodhan on 9/2/19.
//  Copyright © 2019 Riajur Rahman. All rights reserved.
//

import UIKit
import SwiftyJSON

class FoodShopViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    let foodShopViewModel = FoodShopViewModel()
    
    var shopList: [JSON] = [JSON]()

    override func viewDidLoad() {
        super.viewDidLoad()
        initCustomTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        doFetchShops()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    func initCustomTableView() {
        
        tableView.delegate = self
        tableView.dataSource = self
        
        let xib = UINib(nibName: "ShopInfoCell", bundle: nil)
        tableView.register(xib, forCellReuseIdentifier: "Cell")
    }
    
    private func doFetchShops() {
        SwiftOverlays.showTextOverlay(self.view, text: "Please wait...")
        foodShopViewModel.fetchShops()
        
        foodShopViewModel.showAlertClosure = {
            if let error = self.foodShopViewModel.error {
                print(error.localizedDescription)
            }
        }
        
        foodShopViewModel.didFinishFetch = {
            do {
                SwiftOverlays.removeAllBlockingOverlays()
                self.shopList = [JSON]()
                if let data = self.foodShopViewModel.shops {
                    for (_, object) in data {
                        self.shopList.append(object)
                    }
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
}


extension FoodShopViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if shopList.count > 0 {
            return shopList.count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if shopList.count > 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ShopInfoCell
            if let shopName = shopList[indexPath.row]["shop_name"].string {
                cell.shopName.text = shopName
            }
            else {
                cell.shopName.text = "N/A"
            }
            
            if let address = shopList[indexPath.row]["address"].string {
                cell.address.text = address
            }
            else {
                cell.address.text = ""
            }
            
            if let phone = shopList[indexPath.row]["phone"].string {
                cell.phoneNumber.text = phone
            }
            else if let phone = shopList[indexPath.row]["phone"].int {
                cell.phoneNumber.text = String(phone)
            }
            else {
                cell.phoneNumber.text = ""
            }
            return cell
        }
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if indexPath.row < shopList.count {
            var shopName = ""
            var shopId = 0
            if let name = shopList[indexPath.row]["shop_name"].string {
                shopName = name
            }
            
            if let id = shopList[indexPath.row]["id"].int {
                shopId = id
            }
            else if let id = shopList[indexPath.row].string {
                shopId = Int(id)!
            }
            
            let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let foodController = mainStoryboard.instantiateViewController(withIdentifier: "FoodVC") as? FoodViewController
            foodController?.shopId = shopId
            foodController?.shopName = shopName
            self.navigationController?.pushViewController(foodController!, animated: true)
        }
    }
}



