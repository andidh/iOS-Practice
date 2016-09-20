//
//  ViewController.swift
//  StoreSearch
//
//  Created by Dehelean Andrei on 9/20/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    // MARK: - Constants
    private struct SearchControllerConstants {
        static let cellIdentifier = "SearchResultCell"
        static let nothingFoundCellIdentifier = "NothingFoundCell"
    }

    // MARK: - Properties
    var searchResults = [SearchResult]()
    var hasSearched = false
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var searchBar: UISearchBar!
    
    // MARK: - Overridden methods
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.contentInset = UIEdgeInsets(top: 64, left: 0, bottom: 0, right: 0)
        tableView.rowHeight = 80
        var cellNib = UINib(nibName: SearchControllerConstants.cellIdentifier, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: SearchControllerConstants.cellIdentifier)
        cellNib = UINib(nibName: SearchControllerConstants.nothingFoundCellIdentifier, bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: SearchControllerConstants.nothingFoundCellIdentifier)
        
    }
    
    // MARK: - Class methods
    
    
    // MARK: - IBActions
    
    
    // MARK: - 
    
    // MARK: -

}


// MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        searchResults = [SearchResult]()
        
        if searchBar.text != "Justin bieber" {
            for i in 0...2 {
                let item = SearchResult()
                item.name = String(format: "Fake result %d for", i, searchBar.text!)
                item.artistName = searchBar.text!
                searchResults.append(item)
            }
        }
        hasSearched = true
        tableView.reloadData()
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}


// MARK: - UITableView DataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        }
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if searchResults.isEmpty {
            return tableView.dequeueReusableCellWithIdentifier(SearchControllerConstants.nothingFoundCellIdentifier, forIndexPath: indexPath)
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(SearchControllerConstants.cellIdentifier, forIndexPath: indexPath) as! SearchResultCell
            
            if searchResults.count == 0 {
                cell.nameLabel.text = "No result"
                cell.artistNameLabel.text = ""
            } else {
                cell.nameLabel.text = searchResults[indexPath.row].name
                cell.artistNameLabel.text = searchResults[indexPath.row].artistName
            }
            
            return cell
        }
    }
}

// MARK: - UITableView Delegate
extension SearchViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        if searchResults.isEmpty {
            return nil
        } else {
            return indexPath
        }
    }
    
}
