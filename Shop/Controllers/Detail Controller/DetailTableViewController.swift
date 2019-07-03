//
//  DetailTableViewController.swift
//  Shop
//
//  Created by Timur Saidov on 01/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    
    // MARK: Public Properties
    
    var clothes: Clothes?
    weak var delegate: ReloadShopTableViewDelegate?
    var clothesName: String?
    var clothesDescription: String?
    var clothesCost: Int?
    weak var orderDelegate: AddToOrderDelegate?
    
    
    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupOrderDelegate()
        setupTableView()
        hideKeyboard()
    }
    
    deinit {
        print("DetailTableViewController \(#function)")
    }
    
    
    // MARK: Private
    
    private func setupNavBar() {
        if clothes != nil {
            navigationItem.largeTitleDisplayMode = .never
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(handleAddInBasket))
        } else {
            navigationItem.title = Titles.sell.rawValue
            navigationItem.rightBarButtonItem = UIBarButtonItem(title: Titles.save.rawValue, style: .done, target: self, action: #selector(handleSave))
            navigationItem.rightBarButtonItem?.isEnabled = false
        }
    }
    
    @objc private func handleAddInBasket() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        DispatchQueue.global(qos: .default).async { [weak self] in
            guard let self = self else { return }
            var clothesJSON: [String: Any] = [:]
            clothesJSON[GoodsDetail.name.rawValue] = self.clothes?.name
            clothesJSON[GoodsDetail.description.rawValue] = self.clothes?.description
            clothesJSON[GoodsDetail.cost.rawValue] = self.clothes?.cost
            clothesJSON[GoodsDetail.count.rawValue] = 1
            clothesJSON[GoodsDetail.price.rawValue] = self.clothes?.cost
            UserDefaults.standard.set(clothesJSON, forKey: "Order")
            UserDefaults.standard.synchronize()
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
                guard let self = self else { return }
                self.navigationItem.rightBarButtonItem?.isEnabled = true
                let alertController = AlertManager.shared.addClothesToOrderAlert()
                self.present(alertController, animated: true, completion: nil)
                self.orderDelegate?.updateOrder(isAdditing: true)
            }
        }
    }
    
    @objc private func handleSave() {
        guard
            let name = clothesName,
            let description = clothesDescription,
            let cost = clothesCost
            else { return }
        let newClothes = Clothes(name: name,
                                 description: description,
                                 cost: cost,
                                 count: nil,
                                 price: nil)
        zeroingInfo()
        delegate?.reloadTableView(with: newClothes)
    }
    
    private func zeroingInfo() {
        navigationItem.rightBarButtonItem?.isEnabled = false
        clothesName = nil
        clothesDescription = nil
        clothesCost = nil
        guard
            let nameCell = tableView.cellForRow(at: IndexPath(row: 0, section: 0)) as? DetailTableViewCell,
            let descriptionCell = tableView.cellForRow(at: IndexPath(row: 0, section: 1)) as? DetailTableViewCell,
            let costCell = tableView.cellForRow(at: IndexPath(row: 0, section: 2)) as? DetailTableViewCell
            else { return }
        nameCell.infoTextField.text = .empty
        descriptionCell.infoTextField.text = .empty
        costCell.infoTextField.text = .empty
    }
    
    private func setupOrderDelegate() {
        if let navController = tabBarController?.viewControllers?.last as? UINavigationController,
            let buyController = navController.viewControllers.first as? BuyViewController {
            orderDelegate = buyController
        }
    }
    
    private func setupTableView() {
        tableView.estimatedRowHeight = 44
        tableView.rowHeight = UITableView.automaticDimension
        tableView.allowsSelection = false
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func hideKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
    // MARK: Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if clothes != nil {
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! DetailTableViewCell
            
            switch indexPath.section {
            case 0:
                cell.infoLabel.text = Titles.name.rawValue
                cell.descriptionLabel.text = clothes?.name
                return cell
            case 1:
                cell.infoLabel.text = Titles.description.rawValue
                cell.descriptionLabel.text = clothes?.description
                return cell
            case 2:
                cell.infoLabel.text = Titles.cost.rawValue
                guard let cost = clothes?.cost else { return cell }
                cell.descriptionLabel.text = "\(cost) ₽"
                return cell
            default:
                return cell
            }
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "CellBuy", for: indexPath) as! DetailTableViewCell
            switch indexPath.section {
            case 0:
                cell.infoLabel.text = Titles.name.rawValue
                cell.key = .name
                cell.delegate = self
                return cell
            case 1:
                cell.infoLabel.text = Titles.description.rawValue
                cell.key = .description
                cell.delegate = self
                return cell
            case 2:
                cell.infoLabel.text = Titles.cost.rawValue
                cell.infoTextField.keyboardType = .numberPad
                cell.key = .cost
                cell.delegate = self
                return cell
            default:
                return cell
            }
        }
    }
}
