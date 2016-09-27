//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Dehelean Andrei on 9/22/16.
//  Copyright © 2016 Dehelean Andrei. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    enum AnimationStyle {
        case Slide
        case Fade
    }
    // MARK: - Properties
    var searchResult: SearchResult?
    var downloadTask: NSURLSessionDownloadTask?
    var dismissAnimationStyle = AnimationStyle.Fade
    
    // MARK: - IBOutlets
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    
    // MARK: - IBActions
    @IBAction func close(sender: AnyObject) {
        dismissAnimationStyle = .Slide
        dismissViewControllerAnimated(true, completion: nil)
    }
    @IBAction func priceButtonPressed(sender: UIButton) {
        if let url = NSURL(string: searchResult!.storeURL) {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    // MARK: - Overridden methods
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
        modalPresentationStyle = .Custom
        transitioningDelegate = self
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.tintColor = UIColor(red: 20/255, green: 160/255, blue: 160/255, alpha: 1)
        view.backgroundColor = UIColor.clearColor()
        
        popupView.layer.cornerRadius = 10
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
        gestureRecognizer.cancelsTouchesInView = false
        gestureRecognizer.delegate = self
        view.addGestureRecognizer(gestureRecognizer)
        configureUI()
    }
    
    // MARK: - Methods
    func configureUI() {
        if let url = NSURL(string: searchResult!.artworkURL100) {
            downloadTask = artworkImageView.loadImageWithURL(url)
        }
        
        let formatter = NSNumberFormatter()
        formatter.currencyCode = searchResult?.currency
        formatter.numberStyle = .CurrencyStyle
        
        let priceText: String
        if searchResult?.price == 0 {
            priceText = "Free"
        } else if let text = formatter.stringFromNumber(searchResult!.price) {
            priceText = text
        } else {
            priceText = ""
        }
        priceButton.setTitle(priceText, forState: .Normal)
        
        nameLabel.text = searchResult?.name
        if searchResult!.artistName.isEmpty {
            artistNameLabel.text = "Unknown"
        } else {
            artistNameLabel.text = searchResult?.artistName
        }
        kindLabel.text = searchResult?.kindForDisplay()
        genreLabel.text = searchResult?.genre
    }
    
    deinit {
        downloadTask?.cancel()
    }
}


extension DetailViewController: UIViewControllerTransitioningDelegate {
    func presentationControllerForPresentedViewController(presented: UIViewController, presentingViewController presenting: UIViewController, sourceViewController source: UIViewController) -> UIPresentationController? {
        
        return DimmingPresentationController(presentedViewController: presented, presentingViewController: presenting)
    }
    
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return BounceAnimationController()
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        switch dismissAnimationStyle {
        case .Slide:
            return SlideOutAnimation()
        case .Fade:
            return FadeOutAnimationController()
        }
    }
}

extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldReceiveTouch touch: UITouch) -> Bool {
        return touch.view == self.view
    }
    
}