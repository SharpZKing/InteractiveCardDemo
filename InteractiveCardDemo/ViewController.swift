//
//  ViewController.swift
//  InteractiveCardDemo
//
//  Created by zjfsharp on 2020/7/29.
//  Copyright © 2020 zjfsharp. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    enum CardState {
        case expand
        case collapsed
    }
    
    var cardViewController: CardViewController!
    var visualEffectView: UIVisualEffectView!
    
    let cardViewheight: CGFloat = 600
    let cardHandleAreaHeight: CGFloat = 65
    
    var cardVisible = false
    var nextState:CardState {
        return cardVisible ? .collapsed : .expand
    }
    
    var runningAnimators = [UIViewPropertyAnimator]()
    var animatorProgressWhenInterupted: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .link
        setCardView()
    }
    
    override func viewDidLayoutSubviews() {
        
    }
    
    func setCardView() {
        visualEffectView = UIVisualEffectView()
        visualEffectView.frame = self.view.frame
        self.view.addSubview(visualEffectView)
        
        cardViewController = CardViewController(nibName: "CardViewController", bundle: nil)
        addChild(cardViewController)
        self.view.addSubview(cardViewController.view)
        
        cardViewController.view.frame = CGRect(x: 0, y: self.view.frame.height - cardHandleAreaHeight, width: self.view.bounds.width, height: cardViewheight)
        cardViewController.view.clipsToBounds = true
        
    }


}

