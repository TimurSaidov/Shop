//
//  ViewController+UISearchResultsUpdating.swift
//  Shop
//
//  Created by Timur Saidov on 02/07/2019.
//  Copyright © 2019 Timur Saidov. All rights reserved.
//

import UIKit

extension ViewController: UISearchResultsUpdating {
    
    
    // MARK: Search results updating
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        filterContentForSearch(searchText)
    }
    
    
    // MARK: Private
    
    private func filterContentForSearch(_ searchText: String, scope: String = "All") {
        filteredShop = shop.filter({ clothes -> Bool in
            return clothes.name.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
    }
}
