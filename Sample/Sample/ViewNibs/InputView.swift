//
//  InputView.swift
//  ColourMemory
//
//  Created by Elie Melki on 23/07/18.
//  Copyright © 2018 Eli Melki Corp. All rights reserved.
//

import UIKit
import BRUIKit

@IBDesignable
open class InputView: UINibView {

    @IBOutlet open weak var errorLabel: UILabel!
    @IBOutlet open weak var titleLabel: UILabel!
    @IBOutlet open weak var inputTextField: UITextField!
    
    @IBInspectable open var titleLabelText:String? {
        didSet {
            self.titleLabel?.text = self.titleLabelText
        }
    }
    
    @IBInspectable open var inputTextFieldPlaceHolder:String? {
        didSet {
            self.inputTextField?.placeholder = self.inputTextFieldPlaceHolder
        }
    }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        self.inputTextField?.placeholder = self.inputTextFieldPlaceHolder
        self.titleLabel?.text = self.titleLabelText
    }
    
    override open func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        self.inputTextField?.placeholder = self.inputTextFieldPlaceHolder
        self.titleLabel?.text = self.titleLabelText
    }
    
    
}
