//
//  BaseQuerySearchTableViewController.swift
//  Think
//
//  Created by denis zaytcev on 8/12/15.
//  Copyright (c) 2015 Parse. All rights reserved.
//

import Foundation
import Parse
import ParseUI
import Bolts

class BaseQuerySearchTableViewController: BaseQueryTableViewController {
    var searchController: UISearchController?
    private var searchText: String = ""

    func getSearchText() -> String? {
        return searchText.isEmpty ? nil: searchText.lowercaseString
    }
    
    func configureSearchBar() {
        self.extendedLayoutIncludesOpaqueBars = true
        self.definesPresentationContext = true
        
        searchController = UISearchController(searchResultsController: nil)
        searchController?.searchResultsUpdater = self
        searchController?.hidesNavigationBarDuringPresentation = true
        searchController?.dimsBackgroundDuringPresentation = false
        searchController?.searchBar.sizeToFit()
        searchController?.searchBar.showsCancelButton = false
        searchController?.searchBar.tintColor = kColorNavigationBar
        searchController?.searchBar.translucent = false
        searchController?.searchBar.barTintColor = UIColor.whiteColor()
        searchController?.searchBar.searchBarStyle = UISearchBarStyle.Default
        searchController?.searchBar.delegate = self
        searchController?.searchBar.setBackgroundImage(UIImage(), forBarPosition: UIBarPosition.Any, barMetrics: UIBarMetrics.Default)
        self.tableView.tableHeaderView = searchController!.searchBar
    }
}

extension BaseQuerySearchTableViewController: UISearchResultsUpdating {
    func updateSearchResultsForSearchController(searchController: UISearchController) {
    }
}

extension BaseQuerySearchTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        self.searchText = ""
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchText = searchBar.text
        self.loadObjects()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchText = ""
        self.loadObjects()
    }
}