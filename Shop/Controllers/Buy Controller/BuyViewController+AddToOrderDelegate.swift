//
//  BuyViewController+AddToOrderDelegate.swift
//  Shop
//
//  Created by Timur Saidov on 02/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

extension BuyViewController: AddToOrderDelegate {
    
    func updateOrder(isAdditing: Bool) {
        if isAdditing {
            guard var clothesJSON = UserDefaults.standard.object(forKey: "Order") as? [String: Any] else { return }
            guard var clothes = Clothes.parse(json: clothesJSON) else { return }
            var insertedClothes = true
            var index: Int?
            updateOrderProperties(with: &clothes, clothesJSON: &clothesJSON, insertedClothes: &insertedClothes, index: &index)
            updateBadgeValue()
            updateTableViewIfNeeded(insertedClothes: insertedClothes, index: index)
            setNewValues()
        } else {
            guard let ordersJSON = UserDefaults.standard.object(forKey: "Orders") as? [[String: Any]] else { return }
            for item in ordersJSON {
                guard let clothes = Clothes.parse(json: item) else { return }
                order.append(clothes)
                if let clothesPrice = clothes.price {
                    price += clothesPrice
                }
            }
            guard let count = UserDefaults.standard.object(forKey: "OrderCount") as? Int else { return }
            setupOrderProperties(ordersJSON: ordersJSON, count: count)
            updateBadgeValue()
//            UserDefaults.standard.removeObject(forKey: "Order")
//            UserDefaults.standard.removeObject(forKey: "Orders")
//            UserDefaults.standard.removeObject(forKey: "OrderCount")
        }
    }
    
    
    // MARK: Private
    
    private func updateOrderProperties(with clothes: inout Clothes, clothesJSON: inout [String: Any], insertedClothes: inout Bool, index: inout Int?) {
        loop: for item in order {
            if item.name == clothes.name {
                insertedClothes = false
                break loop
            }
        }
        if insertedClothes {
            order.append(clothes)
            orders.append(clothesJSON)
        } else {
            loop: for item in 0..<orders.count {
                guard
                    let nameItem = orders[item][GoodsDetail.name.rawValue] as? String,
                    let nameJSON = clothesJSON[GoodsDetail.name.rawValue] as? String
                    else { return }
                if nameItem == nameJSON {
                    index = item
                    break loop
                }
            }
            guard let i = index else { return }
            guard
                let count = order[i].count,
                let price = order[i].price
                else { return }
            orders.remove(at: i)
            clothesJSON[GoodsDetail.count.rawValue] = count + 1
            clothesJSON[GoodsDetail.cost.rawValue] = price + clothes.cost
            orders.insert(clothesJSON, at: i)
            order.remove(at: i)
            clothes.count = count + 1
            clothes.price = price + clothes.cost
            order.insert(clothes, at: i)
        }
        price += clothes.cost
        orderCount += 1
    }
    
    private func updateBadgeValue() {
        if orderCount == 0 {
            self.navigationController?.tabBarItem.badgeValue = nil
        } else {
            self.navigationController?.tabBarItem.badgeValue = "\(self.orderCount)"
        }
    }
    
    private func updateTableViewIfNeeded(insertedClothes: Bool, index: Int?) {
        if tableView != nil {
            tableView.beginUpdates()
            if insertedClothes {
                tableView.insertRows(at: [IndexPath(row: order.count - 1, section: 0)], with: .automatic)
            } else {
                guard let i = index else { return }
                tableView.reloadRows(at: [IndexPath(row: i, section: 0)], with: .automatic)
            }
            tableView.endUpdates()
            buyButton.isHidden = false
            buyButton.setTitle("Купить за \(price) ₽", for: .normal)
        }
    }
    
    private func setNewValues() {
        UserDefaults.standard.set(orders, forKey: "Orders")
        UserDefaults.standard.set(orderCount, forKey: "OrderCount")
        UserDefaults.standard.synchronize()
    }
    
    private func setupOrderProperties(ordersJSON: [[String: Any]], count: Int) {
        orders = ordersJSON
        orderCount = count
    }
}
