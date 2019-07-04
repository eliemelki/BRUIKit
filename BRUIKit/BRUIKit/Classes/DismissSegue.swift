//
//  DismissSegue.swift
//  BRUIKit
//
//  Created by Eli Melki on 2/07/19.
//  Copyright © 2019 Eli Melki. All rights reserved.
//

import UIKit

class DismissSegue: UIStoryboardSegue {
    override func perform() {
        self.source.presentingViewController?.dismiss(animated: true, completion: nil)
    }
}
