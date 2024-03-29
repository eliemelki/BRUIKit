//
//  MenuViewController.swift
//
//  Created by Elie Melki on 28/08/18.
//  Copyright © 2018. All rights reserved.
//

import UIKit

/**
 * @SlideMenuViewController flexible slide menu.
 * If used within a storboard make sure to create SlideMainControllerSegue and SlideMenuControllerSegue.
 * The segue should have identifier "main" and "menu" respectively. Anytime you need to replace the main controller you can execute SlideMainControllerSegue with identifier main.
 * You can also change main content programtically by calling @setMainController
 * From any main or menu ViewController you can call slideMenuController property to have reference to SlideMenuViewController. This can return nil, if you are not within.
**/

open class SlideMenuViewController: UIViewController{
    
    // MARK: UI Properties
    fileprivate var sideViewController:UIViewController = UIViewController()
    fileprivate var mainViewController:UIViewController = UIViewController()
    
    @IBOutlet private var menuIconButton:UIButton!
    
    private var mainContentView:UIView!
    private var leftViewContainer:UIView!
    
    private var leftContentView:UIView!
    private var leftOverlayView:UIView!
    
    // MARK: Configuration Properties
    
    private(set) var isOpened = false
    
    private var slideConstraints: [NSLayoutConstraint] = [] {
        willSet {
            NSLayoutConstraint.deactivate(slideConstraints)
        }
        didSet {
            NSLayoutConstraint.activate(slideConstraints)
        }
    }
    
    //Can be set to disable automatic menu close on main content change.
    @IBInspectable open var automaticallyHideMenuOnMainChange: Bool = true
    
    //Can be set to hide the menu icon at all time.
    @IBInspectable open var menuIconVisible: Bool = true {
        didSet {
            if let icon = self.menuIconButton {
                icon.isHidden = menuIconVisible
            }
        }
    }
    //define transition animation when replacing main view controller. You can override `AnimationTransition` protocol and set the property to change the behaviour.
    open var mainViewControllerAnimationTransition:AnimationTransition = SlideMenuMainAnimationTransition()
    
    // MARK: Init
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    public init(slideController: UIViewController, mainController: UIViewController, menuButton: UIButton? = nil) {
        self.sideViewController = slideController
        self.mainViewController = mainController
        self.menuIconButton = menuButton
        super.init(nibName: nil, bundle: nil)
    }
    
    // MARK: ViewController Methods
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        self.performSegue(withIdentifier: "main", sender: nil)
        self.performSegue(withIdentifier: "menu", sender: nil)
    }
    
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.setupGesture()
    }
    
    // MARK: Public Methods
    
    //Close slide menu.
    open func closeSlide() {
        guard isOpened else {
            return
        }
        
        self.isOpened = false
        self.slideConstraints = [self.leftViewContainer.trailingAnchor.constraint(equalTo: self.view.leadingAnchor)]
        self.leftOverlayView.isHidden = true
        
        UIView.animate(withDuration: 0.3, animations: {
             self.view.layoutIfNeeded()
        }) { (v) in
            self.leftContentView.isHidden = true
        }
        
    }
    
    //Open slide menu.
    open func openSlide() {
        guard !isOpened else {
            return
        }
        
        self.leftContentView.isHidden = false
        self.isOpened = true
        self.slideConstraints = [self.leftContentView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor)]
        
        UIView.animate(withDuration: 0.3, animations: {
              self.view.layoutIfNeeded()
        }) { (v) in
            self.leftOverlayView.isHidden = false
        }
       
    }
    
   //Toogle slide menu.
    @objc open func toogleSlide() {
        if (isOpened) {
            closeSlide()
        }else {
            openSlide()
        }
    }
    
    //Change Main ViewController content.
    open func setMainController(to viewController:UIViewController, animated: Bool = false,  completionHandler: @escaping () -> Void = {}) {
        
        if (viewController == self.mainViewController) {
            return
        }
        
        let fromViewController = self.mainViewController
        self.addController(controller: viewController, inView: self.mainContentView)
        self.didAddMainController(viewController: viewController)
        
        if (animated) {
            self.mainViewControllerAnimationTransition.animateTransition(from: fromViewController.view, to: viewController.view, completionHandler: {
                self.removeController(content: fromViewController)
                self.addMenuButton(mainViewController: viewController)
                completionHandler()
            } )
        }else {
            self.removeController(content: fromViewController)
            self.addMenuButton(mainViewController: viewController)
            completionHandler()

        }
    }
    
    // MARK: Private Methods
    
    private func didAddMainController(viewController:UIViewController) {
        self.mainViewController = viewController
        self.mainViewController.slideMenuController = self
        
        if (automaticallyHideMenuOnMainChange) {
            self.closeSlide()
        }
        
        self.addMenuButton(mainViewController: viewController)
    }
    
    private func setupGesture() {
        
        view.isUserInteractionEnabled = true
        
        let  leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeLeft))
        leftSwipe.direction = .left
        view.addGestureRecognizer(leftSwipe)
        
        
        let rightSwipe = UISwipeGestureRecognizer(target: self, action: #selector(didSwipeRight))
        rightSwipe.direction = .right
        view.addGestureRecognizer(rightSwipe)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOverlayView))
        self.leftOverlayView.isUserInteractionEnabled = true
        self.leftOverlayView.addGestureRecognizer(tapGesture)
        
        
        if let menuButton = self.menuIconButton {
            menuButton.addTarget(self, action: #selector(toogleSlide), for: .touchUpInside)
        }
    }
    
    private func setupUI() {
        self.setupMainUI()
        self.setupMenuUI()
        
        
        self.addController(controller: self.sideViewController, inView: self.leftContentView)
        self.sideViewController.slideMenuController = self
        self.addController(controller: self.mainViewController, inView: self.mainContentView)
        self.didAddMainController(viewController: self.mainViewController)
        
    }
    
     private func setupMainUI() {
        self.mainContentView = UIView(frame: self.view.bounds)
        self.mainContentView.pin(toView: view)
     }

    private func setupMenuUI() {
        self.leftViewContainer = UIView(frame: self.view.bounds)
        self.leftViewContainer.backgroundColor = UIColor.clear
        self.leftViewContainer.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.leftViewContainer)
        
        self.leftViewContainer.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        self.leftViewContainer.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        self.leftViewContainer.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
        
        self.slideConstraints = [self.leftViewContainer.trailingAnchor.constraint(equalTo: self.view.leadingAnchor)]
        
        
        self.leftContentView = UIView(frame: self.view.bounds)
        self.leftContentView.isHidden = true
        self.leftContentView.translatesAutoresizingMaskIntoConstraints = false
        self.leftViewContainer.addSubview(self.leftContentView)
        self.leftContentView.bottomAnchor.constraint(equalTo: leftViewContainer.bottomAnchor).isActive = true
        self.leftContentView.topAnchor.constraint(equalTo: leftViewContainer.topAnchor).isActive = true
        self.leftContentView.widthAnchor.constraint(equalTo: leftViewContainer.widthAnchor, multiplier: 3/4.0).isActive = true
        self.leftContentView.leadingAnchor.constraint(equalTo: leftViewContainer.leadingAnchor).isActive = true
        
        
        self.leftOverlayView = UIView(frame: view.bounds)
        self.leftOverlayView.translatesAutoresizingMaskIntoConstraints = false
        self.leftOverlayView.backgroundColor = UIColor.black
        self.leftOverlayView.alpha = 0.3
        self.leftViewContainer.addSubview(leftOverlayView)
        self.leftOverlayView.leadingAnchor.constraint(equalTo: self.leftContentView.trailingAnchor).isActive = true
        self.leftOverlayView.topAnchor.constraint(equalTo: self.leftViewContainer.topAnchor).isActive = true
        self.leftOverlayView.trailingAnchor.constraint(equalTo: self.leftViewContainer.trailingAnchor).isActive = true
        self.leftOverlayView.bottomAnchor.constraint(equalTo: self.leftViewContainer.bottomAnchor).isActive = true
        self.leftOverlayView.isHidden = true
    }
    
    private func addMenuButton(mainViewController:UIViewController) {
        if let button = self.menuIconButton {
            button.removeFromSuperview()
            if let navigationController = mainViewController as? UINavigationController {
                let menuButton = UIBarButtonItem(customView: button)
                let viewcontroller = navigationController.viewControllers[0]
                viewcontroller.navigationItem.leftBarButtonItem = menuButton
            }else {
                button.translatesAutoresizingMaskIntoConstraints = false
                let mainView = self.mainContentView!
                mainView.addSubview(button)
                if #available(iOS 11, *) {
                    let guide = mainView.safeAreaLayoutGuide
                    button.topAnchor.constraint(equalTo: guide.topAnchor, constant: 10).isActive = true
                }else {
                    button.topAnchor.constraint(equalTo: mainView.topAnchor, constant: 10).isActive = true
                }
                button.leadingAnchor.constraint(equalTo: mainView.leadingAnchor, constant: 15).isActive = true
                button.layoutIfNeeded()
            }
           
        }
    }
   
    private func addController(controller: UIViewController, inView: UIView) {
        controller.willMove(toParent: self)
        self.addChild(controller)
        controller.view.pin(toView: inView)
        controller.didMove(toParent: self)
    }
    private func removeController(content: UIViewController) {
        content.willMove(toParent: nil)
        content.view.removeFromSuperview()
        content.removeFromParent()
        content.didMove(toParent: nil)
    }
    
    // MARK: Action Methods
    
    @objc private func didTapOverlayView() {
        self.closeSlide()
    }

    
    @objc private func didTapMenu() {
        self.toogleSlide()
    }
    
    @objc  func didSwipeLeft() {
        self.closeSlide()
    }
    
    @objc  func didSwipeRight() {
        self.openSlide()
    }
}


// MARK: Extensions.

//Adding slideMenuController property to reference the SlideMenuViewController.
private var slideMenuControllerKey: UInt8 = 0
public extension UIViewController {
    fileprivate(set) var slideMenuController: SlideMenuViewController? {
        get {
            return objc_getAssociatedObject(self, &slideMenuControllerKey) as? SlideMenuViewController
        }
        set  {
            objc_setAssociatedObject(self, &slideMenuControllerKey, newValue,.OBJC_ASSOCIATION_ASSIGN)
        }
    }
}

// MARK: Segues.

//SlideMainControllerSegue segue used in Storyboard to set the MainViewController
open class SlideMainControllerSegue : UIStoryboardSegue {
  
    override open func perform() {
        if let source = self.source as? SlideMenuViewController {
            self.updateMainController(side: source, controller: destination)
        } else if let source = self.source.slideMenuController {
            self.updateMainController(side: source, controller: destination)
        }
    }
    
    func updateMainController(side:SlideMenuViewController, controller: UIViewController) {
        if (side.isViewLoaded) {
            side.setMainController(to: destination, animated: UIView.areAnimationsEnabled)
        }else {
            side.mainViewController = destination
        }
    }
}

//SlideMenuControllerSegue segue used in Storyboard to set the Menu
open class SlideMenuControllerSegue : UIStoryboardSegue {

    override open func perform() {
        if let source = self.source as? SlideMenuViewController {
            self.updateMenuController(side: source, controller: destination)
        } else if let source = self.source.slideMenuController {
            self.updateMenuController(side: source, controller: destination)
        }
        
    }
    
    func updateMenuController(side:SlideMenuViewController, controller: UIViewController) {
         side.sideViewController = controller
    }
}

// MARK: Animation.
//SlideMenuMainAnimationTransition conforms to AnimationTransition protocol which implements the replace main controller animation.
class SlideMenuMainAnimationTransition: AnimationTransition {
    func animateTransition(from: UIView, to: UIView, completionHandler: @escaping () -> Void) {
        let duration = 0.5
        to.alpha = 0
        
        UIView.animate(withDuration: duration, animations: {
            to.alpha = 1
            from.alpha = 0
        }) { (finished) in
            completionHandler()
        }
    }
}

