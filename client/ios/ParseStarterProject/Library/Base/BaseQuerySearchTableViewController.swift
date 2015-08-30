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
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchBarTopLayoutConstraint: NSLayoutConstraint!
    
    private var searchText: String = ""
    var updateObjectsAfterCancel: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customizeSearchBar()
    }
    
    func customizeSearchBar() {
        self.searchBar.layer.borderWidth = 1
        self.searchBar.layer.borderColor = UIColor.whiteColor().CGColor
    }
    
    func getSearchText() -> String? {
        return searchText.isEmpty ? nil: searchText.lowercaseString
    }
    
    override func topConstraintForNavigationBar() -> NSLayoutConstraint? {
        return nil//self.searchBarTopLayoutConstraint
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.automaticallyAdjustsScrollViewInsets == true {
            self.searchBarTopLayoutConstraint.constant = 64
        }
    }
}

extension BaseQuerySearchTableViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(searchBar: UISearchBar){
        self.searchText = ""
        searchBar.showsCancelButton = true
    }
    
    func searchBarShouldBeginEditing(searchBar: UISearchBar) -> Bool {
        if let navigationBar = self.defineNavigationBar() {
            if let topNavigationBar = HelperConstraint.findTopConstraint(navigationBar) {
                topNavigationBar.constant = -44
            }
            self.searchBarTopLayoutConstraint.constant = 20
            
            UIView.animateWithDuration(0.257, delay: 0,
                options: .BeginFromCurrentState | UIViewAnimationOptions.CurveEaseInOut,
                animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    navigationBar.alpha = 0
                }, completion: nil)
        }

        return true
    }
    
    func animateNavigationVarAfterEditing() {
        if let navigationBar = self.defineNavigationBar() {
            if let topNavigationBar = HelperConstraint.findTopConstraint(navigationBar) {
                topNavigationBar.constant = 20
            }
            self.searchBarTopLayoutConstraint.constant = 64
            
            UIView.animateWithDuration(0.257, delay: 0,
                options: .BeginFromCurrentState | UIViewAnimationOptions.CurveEaseInOut,
                animations: { () -> Void in
                    self.view.layoutIfNeeded()
                    navigationBar.alpha = 1
                }, completion: nil)
        }
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.searchText = ""
        self.hideKeyboard()
        searchBar.showsCancelButton = false
        self.animateNavigationVarAfterEditing()
        
        if self.updateObjectsAfterCancel {
            self.loadObjects()
        }
        
    }
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.searchText = searchBar.text
        self.clear()
        self.loadObjects()
    }
    
    func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        self.searchText = ""
    }
}