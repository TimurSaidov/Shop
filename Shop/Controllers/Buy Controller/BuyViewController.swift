//
//  BuyViewController.swift
//  Shop
//
//  Created by Timur Saidov on 02/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class BuyViewController: UIViewController {

    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var buyButton: UIButton!
    @IBOutlet weak var plugView: UIView!
    
    
    // MARK: Public Properties
    
    var order: [Clothes] = []
    var orders: [[String: Any]] = []
    var orderCount = 0
    var price = 0
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavBar()
        setupTableView()
        setupView()
    }
    

    // MARK: Private
    
    private func setupNavBar() {
        navigationItem.title = Titles.buy.rawValue
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func setupView() {
        buyButton.layer.cornerRadius = 5
        if price != 0 && orderCount != 0 {
            plugView.isHidden = true
            buyButton.setTitle("Купить за \(price) ₽", for: .normal)
        } else {
            plugView.isHidden = false
        }
        buyButton.addTarget(self, action: #selector(handleBuyButton), for: .touchUpInside)
    }
    
    @objc private func handleBuyButton() {
        buyButton.isEnabled = false
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            let alertController = AlertManager.shared.orderDoneAlert(with: self.price)
            self.present(alertController, animated: true, completion: nil)
            self.zeroingProperties()
            self.setNewValues()
            self.updateView()
        }
    }
    
    private func zeroingProperties() {
        order = []
        orders = []
        orderCount = 0
        price = 0
    }
    
    private func setNewValues() {
        UserDefaults.standard.removeObject(forKey: "Order")
        UserDefaults.standard.removeObject(forKey: "Orders")
        UserDefaults.standard.removeObject(forKey: "OrderCount")
    }
    
    private func updateView() {
        buyButton.isEnabled = true
        buyButton.setTitle(nil, for: .normal)
        navigationController?.tabBarItem.badgeValue = nil
        tableView.reloadData()
        plugView.isHidden = false
    }
}
