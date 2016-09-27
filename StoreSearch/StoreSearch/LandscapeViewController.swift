//
//  LandscapeViewController.swift
//  StoreSearch
//
//  Created by Dehelean Andrei on 9/24/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class LandscapeViewController: UIViewController {
    
    // MARK: - Properties
    var searchResults: [SearchResult]?
    private var firstTime = true
    
    
    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    // MARK: - IBActions
    @IBAction func pageChanged(sender: UIPageControl) {
        UIView.animateWithDuration(0.3, delay: 0, options: .CurveEaseInOut, animations: { 
            self.scrollView.contentOffset = CGPoint(x: self.scrollView.bounds.size.width * CGFloat(sender.currentPage), y: 0)
            }, completion: nil)
    }
    
    
    // MARK: - Overridden methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.removeConstraints(view.constraints)
        view.translatesAutoresizingMaskIntoConstraints = true
        
        scrollView.removeConstraints(scrollView.constraints)
        scrollView.translatesAutoresizingMaskIntoConstraints = true
        
        pageControl.removeConstraints(pageControl.constraints)
        pageControl.translatesAutoresizingMaskIntoConstraints  = true

        scrollView.backgroundColor = UIColor(patternImage: UIImage(named: "LandscapeBackground")!)
        pageControl.numberOfPages = 0
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        scrollView.frame = view.bounds
        
        pageControl.frame = CGRect(x: 0, y: view.frame.size.height - pageControl.frame.size.height, width: view.frame.size.width, height: pageControl.frame.size.height)
        
        if firstTime {
            firstTime = false
            tileButtons(searchResults!)
        }
    }
    
    // MARK: - Class methods
    private func tileButtons(searchResults: [SearchResult]) {
        var columnsPerPage = 5
        var rowsPerPage = 3
        var itemWidth: CGFloat = 96
        var itemHeight: CGFloat = 88
        var marginX: CGFloat = 0
        var marginY: CGFloat = 20
        
        let scrollViewWidth = scrollView.bounds.size.width
        switch scrollViewWidth {
        case 568:
            columnsPerPage = 6
            itemWidth = 94
            marginX = 2
        case 667:
            columnsPerPage = 7
            itemWidth = 95
            itemHeight = 98
            marginX = 1
            marginY = 29
        case 736:
            columnsPerPage = 8
            rowsPerPage = 4
            itemWidth = 92
        default:
            break
        }
        
        let buttonWidth: CGFloat = 82
        let buttonHeight: CGFloat = 82
        let paddingHorz = (itemWidth - buttonWidth)/2
        let paddingVert = (itemHeight - buttonHeight)/2
        
        var row = 0
        var column = 0
        var x = marginX
        var index = 0
        for searchResult in searchResults {
            // 1
            let button = UIButton(type: .System)
            button.backgroundColor = UIColor.whiteColor()
            button.setTitle("\(index)", forState: .Normal)
            index += 1
            // 2
            button.frame = CGRect(x: x + paddingHorz, y: marginY + CGFloat(row)*itemHeight + paddingVert, width: buttonWidth, height: buttonHeight)
            // 3
            scrollView.addSubview(button) // 4
            row += 1
            
            if row == rowsPerPage {
                row = 0; x += itemWidth;
                column += 1
                if column == columnsPerPage {
                    column = 0; x += marginX * 2
                }
            }
            
            let buttonsPerPage = columnsPerPage * rowsPerPage
            let numPages = 1 + (searchResults.count - 1) / buttonsPerPage
            scrollView.contentSize = CGSize(width: CGFloat(numPages)*scrollViewWidth, height: scrollView.bounds.size.height)
            pageControl.numberOfPages = numPages
        }
    }
    
    
    deinit {
        print("deinit \(self)")
    }
}

extension LandscapeViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(scrollView: UIScrollView) {
        let width = scrollView.bounds.size.width
        let currentPage = Int((scrollView.contentOffset.x + width/1)/width)
        pageControl.currentPage = currentPage
    }
}
