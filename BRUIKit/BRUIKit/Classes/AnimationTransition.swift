//
//  AnimationTransition.swift
//  BRUIKit
//
//  Created by Eli Melki on 3/07/19.
//  Copyright © 2019 Eli Melki. All rights reserved.
//

import Foundation


public protocol AnimationTransition {
    func animateTransition(from: UIView, to: UIView, completionHandler: @escaping () -> Void)
}
