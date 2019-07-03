//
//  ViewController.swift
//  Shop
//
//  Created by Timur Saidov on 01/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    // MARK: Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    
    // MARK: Public Properties
    
    var shop: [Clothes] = []
    var filteredShop: [Clothes] = []
    var searchBarIsEmpty: Bool {
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    weak var orderDelegate: AddToOrderDelegate?
    
    
    // MARK: Private Properties
    
    private let searchController = UISearchController(searchResultsController: nil)
    
    
    // MARK: Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavBar()
        setupSearchController()
        setupOrderDelegate()
        setupTableView()
        fetchClothes()
    }
    
    
    // MARK: Private
    
    private func setupNavBar() {
        navigationItem.title = Titles.shop.rawValue
    }
    
    private func setupSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = Titles.search.rawValue
        searchController.searchBar.tintColor = .black
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    private func setupOrderDelegate() {
        if let navController = tabBarController?.viewControllers?.last as? UINavigationController,
            let buyController = navController.viewControllers.first as? BuyViewController {
            orderDelegate = buyController
        }
        orderDelegate?.updateOrder(isAdditing: false)
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView(frame: .zero)
    }
    
    private func fetchClothes() {
        activityIndicator.startAnimating()
        DispatchQueue.global(qos: .default).async {
            PlistManager.shared.fetchClothes { [weak self] clothesShop in
                guard let self = self else { return }
                self.activityIndicator.stopAnimating()
                self.activityIndicator.isHidden = true
                self.shop = clothesShop
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegue" {
            if let indexPath = tableView.indexPathForSelectedRow {
                guard let dvc = segue.destination as? DetailTableViewController else { return }
                let clothes = isFiltering ? filteredShop[indexPath.row] : shop[indexPath.row]
                dvc.clothes = clothes
            }
        }
    }
}
