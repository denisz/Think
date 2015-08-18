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
//        searchController?.view.backgroundColor = UIColor.whiteColor()
        searchController?.searchResultsUpdater = self
        searchController?.hidesNavigationBarDuringPresentation = false
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
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        let navigationBar = self.defineNavigationBar()
        self.tableViewTopConstraint?.constant = 24
        
        UIView.animateWithDuration(0.357, delay: 0,
            options: .BeginFromCurrentState | UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                self.view.layoutIfNeeded()
            }, completion: nil)
        
        UIView.animateWithDuration(0.5, delay: 0,
            options: UIViewAnimationOptions.CurveEaseInOut,
            animations: { () -> Void in
                navigationBar!.frame.origin.y = -64
                navigationBar!.layer.opacity = 0
            }, completion: nil)

        return true
    }
    
    func animateNavigationVarAfterEditing() {
        let navigationBar = self.defineNavigationBar()
        self.tableViewTopConstraint?.constant = 44
        
        UIView.animateWithDuration(0.375, delay: 0, options: .BeginFromCurrentState | .CurveEaseInOut, animations: { () -> Void in
            self.view.layoutIfNeeded()
            }) { (result) -> Void in
                self.loadObjects()
        }
        
        UIView.animateWithDuration(0.5, delay: 0, options: .CurveEaseInOut,
            animations: { () -> Void in
                navigationBar!.frame.origin.y = 20
                navigationBar!.layer.opacity = 1
            }, completion: nil)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchText = ""
        self.animateNavigationVarAfterEditing()
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchText = searchBar.text
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchText = ""
    }
}