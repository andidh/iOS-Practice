//
//  ChatLogController.swift
//  chat
//
//  Created by Dehelean Andrei on 7/25/16.
//  Copyright © 2016 Imprezzio Global. All rights reserved.
//

import UIKit

class ChatLogController: UICollectionViewController {
    
    // reference for the input text field
    let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView?.backgroundColor = UIColor.whiteColor()
        setupInputComponents()
    }
    
    func setupInputComponents() {
        
        let containerView  = UIView()
        containerView.backgroundColor = UIColor.whiteColor()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // constraint anchors
        //x, y, w, h
        containerView.leftAnchor.constraintEqualToAnchor(view.leftAnchor).active = true
        containerView.bottomAnchor.constraintEqualToAnchor(view.bottomAnchor).active = true
        containerView.widthAnchor.constraintEqualToAnchor(view.widthAnchor).active = true
        containerView.heightAnchor.constraintEqualToConstant(50).active = true
        
        //adding a "send" button to the bottom container
        let sendButton = UIButton(type: .System)
        sendButton.setTitle("Send", forState: .Normal)
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        sendButton.addTarget(self, action: #selector(ChatLogController.handleSend), forControlEvents: .TouchUpInside)
        containerView.addSubview(sendButton)
        //x,y,w,h
        sendButton.rightAnchor.constraintEqualToAnchor(containerView.rightAnchor).active = true
        sendButton.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        sendButton.widthAnchor.constraintEqualToConstant(80).active = true
        sendButton.heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        
        
        // adding the input textField to containerView
        containerView.addSubview(inputTextField)
        //x,y,w,h
        inputTextField.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor, constant: 8).active = true
        inputTextField.centerYAnchor.constraintEqualToAnchor(containerView.centerYAnchor).active = true
        inputTextField.rightAnchor.constraintEqualToAnchor(sendButton.leftAnchor).active = true
        inputTextField .heightAnchor.constraintEqualToAnchor(containerView.heightAnchor).active = true
        
        //adding a top separator line
        let separatorLine = UIView()
        separatorLine.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(separatorLine)
        // x,y,w,h
        separatorLine.leftAnchor.constraintEqualToAnchor(containerView.leftAnchor).active = true
        separatorLine.topAnchor.constraintEqualToAnchor(containerView.topAnchor).active = true
        separatorLine.widthAnchor.constraintEqualToAnchor(containerView.widthAnchor).active = true
        let height = 1 / UIScreen.mainScreen().scale
        separatorLine.heightAnchor.constraintEqualToConstant(height).active = true
    }
    
    func handleSend() {
        
    }
    
    
    
}
