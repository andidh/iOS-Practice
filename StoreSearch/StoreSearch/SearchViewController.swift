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
        static let loadingCellIdentifier = "LoadingCell"
    }

    // MARK: - Properties
    var searchResults = [SearchResult]()
    var hasSearched = false
    var isLoading = false
    
    var dataTask: NSURLSessionDataTask?
    
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
        cellNib = UINib(nibName: "LoadingCell", bundle: nil)
        tableView.registerNib(cellNib, forCellReuseIdentifier: SearchControllerConstants.loadingCellIdentifier)
        
        searchBar.becomeFirstResponder()
    }
    
    // MARK: - Class methods
    func urlWithSearchText(searchText: String) -> NSURL {
        let escapedSearchText = searchText.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLQueryAllowedCharacterSet())!
        let urlString = String(format: "https://itunes.apple.com/search?term=%@", escapedSearchText)
        let url = NSURL(string: urlString)
        return url!
    }
    
    func parseJSON(data: NSData) -> [String:AnyObject]? {        
        do {
            return try NSJSONSerialization.JSONObjectWithData(data, options: []) as? [String:AnyObject]
        } catch {
            print(error)
            return nil
        }
     }
    
    func parseDictionary(dict: [String:AnyObject]) -> [SearchResult] {
        guard let array = dict["results"] as? [AnyObject] else {
            print("Expected array")
            return []
        }
        
        var searchResults = [SearchResult]()
        for resultDict in array {
            if let resultDict = resultDict as? [String:AnyObject] {
                var searchResult: SearchResult?
                if let wrapperType = resultDict["wrapperType"] as? String {
                    switch wrapperType {
                    case "track" :
                        searchResult = parseTrack(resultDict)
                    case "audiobook" :
                        searchResult = parseAudioBook(resultDict)
                    case "software" :
                        searchResult = parseSoftware(resultDict)
                    default:
                        break
                    }
                }
                
                if let result = searchResult {
                    searchResults.append(result)
                }
            }
        }
        return searchResults
    }
    
    func parseTrack(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult()
        searchResult.name = dictionary["trackName"] as! String
        searchResult.artistName = dictionary["artistName"] as! String
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
        searchResult.storeURL = dictionary["trackViewUrl"] as! String
        searchResult.kind = dictionary["kind"] as! String
        searchResult.currency = dictionary["currency"] as! String
        if let price = dictionary["trackPrice"] as? Double {
            searchResult.price = price
        }
        if let genre = dictionary["primaryGenreName"] as? String {
            searchResult.genre = genre
        }
        return searchResult
    }
    func parseAudioBook(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult()
        searchResult.name = dictionary["collectionName"] as! String
        searchResult.artistName = dictionary["artistName"] as! String
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
        searchResult.storeURL = dictionary["collectionViewUrl"] as! String
        searchResult.kind = "audiobook"
        searchResult.currency = dictionary["currency"] as! String
        if let price = dictionary["collectionPrice"] as? Double {
            searchResult.price = price
        }
        if let genre = dictionary["primaryGenreName"] as? String {
            searchResult.genre = genre
        }
        return searchResult
    }
    
    
    func parseSoftware(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult()
        searchResult.name = dictionary["trackName"] as! String
        searchResult.artistName = dictionary["artistName"] as! String
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
        searchResult.storeURL = dictionary["trackViewUrl"] as! String
        searchResult.kind = dictionary["kind"] as! String
        searchResult.currency = dictionary["currency"] as! String
        if let price = dictionary["price"] as? Double {
            searchResult.price = price
        }
        if let genre = dictionary["primaryGenreName"] as? String {
            searchResult.genre = genre
        }
        return searchResult
    }
    
    func parseEBook(dictionary: [String: AnyObject]) -> SearchResult {
        let searchResult = SearchResult()
        searchResult.name = dictionary["trackName"] as! String
        searchResult.artistName = dictionary["artistName"] as! String
        searchResult.artworkURL60 = dictionary["artworkUrl60"] as! String
        searchResult.artworkURL100 = dictionary["artworkUrl100"] as! String
        searchResult.storeURL = dictionary["trackViewUrl"] as! String
        searchResult.kind = dictionary["kind"] as! String
        searchResult.currency = dictionary["currency"] as! String
        if let price = dictionary["price"] as? Double {
            searchResult.price = price
        }
        if let genres: AnyObject = dictionary["genres"] {
            searchResult.genre = (genres as! [String]).joinWithSeparator(", ")
        }
        return searchResult
    }
    
    // MARK: - IBActions
    
    
    // MARK: - UI Methods
    private func showNetworkError() {
        let alert = UIAlertController(title: "Whoops...", message: "There was an error reading from the iTunes Store. Please try again.", preferredStyle: .Alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .Default, handler: nil))
        presentViewController(alert, animated: true, completion: nil)
    }
    
    private func kindForDisplay(kind: String) -> String {
        switch kind {
        case "album":
            return "Album"
        case "audiobook":
            return "Audio Book"
        case "book":
            return "Book"
        case "ebook":
            return "E-Book"
        case "feature-movie":
            return "Movie"
        case "music-video":
            return "Music Video"
        case "podcast":
            return "Podcast"
        case "software":
            return "App"
        case "song":
            return "Song"
        case "tv-episode":
            return "TV Episode"
        default: return kind
        }
    }
    
    // MARK: -

}


// MARK: - SearchBar Delegate
extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        if !searchBar.text!.isEmpty {
            searchBar.resignFirstResponder()
            
            isLoading = true
            dataTask?.cancel()
            
            tableView.reloadData()
            
            hasSearched = true
            searchResults = [SearchResult]()
            
            let url = urlWithSearchText(searchBar.text!)
            dataTask = NSURLSession.sharedSession().dataTaskWithURL(url) { (data, response, error) in
                if let error = error where error.code == -999 {
                    return
                } else if let httpResponse = response as? NSHTTPURLResponse where httpResponse.statusCode == 200 {
                    if let data = data, dict = self.parseJSON(data) {
                        self.searchResults = self.parseDictionary(dict)
                        self.searchResults.sortInPlace(<)
                        
                        dispatch_async(dispatch_get_main_queue()) { 
                            self.isLoading = false
                            self.tableView.reloadData()
                        }
                        return
                    }
                }
                
                dispatch_async(dispatch_get_main_queue(), { 
                    self.hasSearched = true
                    self.isLoading = false
                    self.tableView.reloadData()
                    self.showNetworkError()
                })
            }
            
            dataTask?.resume()
        }
    }
    
    func positionForBar(bar: UIBarPositioning) -> UIBarPosition {
        return .TopAttached
    }
}


// MARK: - UITableView DataSource
extension SearchViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isLoading {
            return 1
        } else if !hasSearched {
            return 0
        } else if searchResults.count == 0 {
            return 1
        }
        return searchResults.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        if isLoading {
            let cell = tableView.dequeueReusableCellWithIdentifier(SearchControllerConstants.loadingCellIdentifier, forIndexPath: indexPath)
            let spinner = cell.viewWithTag(100) as! UIActivityIndicatorView
            spinner.startAnimating()
            return cell
        } else if searchResults.isEmpty {
            return tableView.dequeueReusableCellWithIdentifier(SearchControllerConstants.nothingFoundCellIdentifier, forIndexPath: indexPath)
        } else {
            let cell = tableView.dequeueReusableCellWithIdentifier(SearchControllerConstants.cellIdentifier, forIndexPath: indexPath) as! SearchResultCell
            
            if searchResults.isEmpty {
                cell.nameLabel.text = "No result"
                cell.artistNameLabel.text = ""
            } else {
                let searchResult = searchResults[indexPath.row]
                cell.nameLabel.text = searchResult.name
                let kind = kindForDisplay(searchResult.kind)
                cell.artistNameLabel.text = String(format: "%@ (%@)", searchResult.artistName, kind)
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
        if searchResults.isEmpty || isLoading {
            return nil
        } else {
            return indexPath
        }
    }
    
}
