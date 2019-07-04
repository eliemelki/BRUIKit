//
//  UIView+Pinning.swift
//
//  Created by Elie Melki on 8/23/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

public extension UIView {
    
    func pin(toView: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        toView.addSubview(self)
        self.leadingAnchor.constraint(equalTo: toView.leadingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: toView.topAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: toView.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
        self.setNeedsUpdateConstraints()
    }
    
    func pin(toView: UIView, at: Int) {
        self.translatesAutoresizingMaskIntoConstraints = false
        toView.insertSubview(self, at: at)
        self.leadingAnchor.constraint(equalTo: toView.leadingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: toView.topAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: toView.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
        self.setNeedsUpdateConstraints()
    }
    
    func pin(toView: UIView, belowSubview: UIView) {
        self.translatesAutoresizingMaskIntoConstraints = false
        toView.insertSubview(self, belowSubview: belowSubview)
        
        self.leadingAnchor.constraint(equalTo: toView.leadingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: toView.topAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: toView.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
        self.setNeedsUpdateConstraints()
    }
    
    func pinAsSibling(toView: UIView) {
        let superView = toView.superview
        self.translatesAutoresizingMaskIntoConstraints = false
        superView?.insertSubview(self, belowSubview: toView)
        self.leadingAnchor.constraint(equalTo: toView.leadingAnchor).isActive = true
        self.topAnchor.constraint(equalTo: toView.topAnchor).isActive = true
        self.trailingAnchor.constraint(equalTo: toView.trailingAnchor).isActive = true
        self.bottomAnchor.constraint(equalTo: toView.bottomAnchor).isActive = true
        self.setNeedsUpdateConstraints()
    }
}
