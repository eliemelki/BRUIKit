//
//  UINibView.swift
//  BRUIKit
//
//  Created by Elie Melki on 16/04/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import UIKit


public extension UIView {
    
    private static let CONTENT_VIEW_TAG = 123490875
    
    func applyNib() {
        let clazz = type(of: self)
        let nibname = String(describing: clazz)
        let bundle = Bundle(for: clazz)
        applyNib(bundle, nibname)
    }
    
    func applyNib(_ nibname: String?) {
        let clazz = type(of: self)
        var bundle = Bundle(for: clazz)
        var finalNibname = nibname
        if let nibname = nibname, let lastDotIndex =  nibname.lastIndex(of: ".")  {
            let frameworkRange = nibname.startIndex..<lastDotIndex
            let frameworkId = String(nibname[frameworkRange])
            let nibNameIndex = nibname.index(after: lastDotIndex)
            let nibnameRange = nibNameIndex..<nibname.endIndex
            let newNibname = String(nibname[nibnameRange])
            if let frameworkBundle = Bundle(identifier: frameworkId) {
                bundle = frameworkBundle
                finalNibname = newNibname
            }
        }
        applyNib(bundle, finalNibname)
    }
    
    func applyNib(_ bundle: Bundle?, _ nibname: String?) {
        
        if let contentView = self.viewWithTag(UIView.CONTENT_VIEW_TAG) {
            contentView.removeFromSuperview()
        }
        
        if let nibname = nibname {
            let nib = UINib(nibName: nibname, bundle: bundle)
            let views = nib.instantiate(withOwner: self, options: nil)
            
            if (views.count > 0) {
                let any = views[0]
                if let contentView = any as? UIView {
                    contentView.translatesAutoresizingMaskIntoConstraints = false
                    contentView.tag = UIView.CONTENT_VIEW_TAG
                   
                    self.addSubview(contentView)
                    contentView.pin(toView: self)
                }
            }
        }
    }
}


open class UINibView : UIView {
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
        self.applyNib()
    }
    
    public required  init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor.clear
    }

    //If you dont specify a nibname the class will try to assign the nibname as the view class name and with use the bundle that the view class was created on.
    //If you want to load a different nib that has a different name than the class in the same bundle as the view class, you can specify the name.
    //If you want to load a different nib that is in a different bundle, you will need to specify the bundle/framework id along with the nibname. E.g BR.BRUIkit.nibname
    @IBInspectable
    open var nibname: String? {
        didSet {
            if (nibname != oldValue) {
                self.applyNib(nibname)
            }
        }
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        if (self.nibname == nil) {
            self.applyNib()
        }
        
    }
    
    open override  func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}
