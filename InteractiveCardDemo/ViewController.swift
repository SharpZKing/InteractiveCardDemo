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
        
        let tapGestureRecognizer = UIGestureRecognizer(target: self, action: #selector(ViewController.handleCardTap(recognizer:)))
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(ViewController.handleCardPan(recognize:)))
        cardViewController.handleArea.addGestureRecognizer(tapGestureRecognizer)
        cardViewController.handleArea.addGestureRecognizer(panGestureRecognizer)
        
    }
    
    @objc func handleCardTap(recognizer: UIGestureRecognizer) {
        switch recognizer.state {
        case .ended:
            transitionIfNeeded(state: nextState, duration: 0.9)
        default:
            <#code#>
        }
    }
    
    @objc func handleCardPan(recognize: UIPanGestureRecognizer) {
        switch recognize.state {
        case .began:
            // print("began")
            startInterativeTransition(state: nextState, duration: 0.9)
        case .changed:
            // print("changed")
            let transilation = recognize.translation(in: self.cardViewController.handleArea)
            var fractionComplete = transilation.y / cardViewheight
            fractionComplete = cardVisible ? fractionComplete : -fractionComplete
            updateInteractiveTransition(fractionCompleted: fractionComplete)
        case .ended:
            //  print("ended")
            continueInteractiveTransition()
        default:
            print("default")
        }
    }
    
    func transitionIfNeeded(state: CardState, duration: TimeInterval) {
        if runningAnimators.isEmpty {
            let frameAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .collapsed:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardHandleAreaHeight
                case .expand:
                    self.cardViewController.view.frame.origin.y = self.view.frame.height - self.cardViewheight
                }
            }
            
            frameAnimator.addCompletion {
                _ in
                
                self.cardVisible = !self.cardVisible
                self.runningAnimators.removeAll()
                
            }
            
            frameAnimator.startAnimation()
            runningAnimators.append(frameAnimator)
            
            let cornerRadiusAnimator = UIViewPropertyAnimator(duration: duration, curve: .linear) {
                switch state {
                case .collapsed:
                    self.cardViewController.view.layer.cornerRadius = 0
                case .expand:
                    self.cardViewController.view.layer.cornerRadius = 12
                }
            }
            
            cornerRadiusAnimator.startAnimation()
            runningAnimators.append(cornerRadiusAnimator)
            
            let blurAnimator = UIViewPropertyAnimator(duration: duration, dampingRatio: 1) {
                switch state {
                case .collapsed:
                    self.visualEffectView.effect = nil
                case .expand:
                    self.visualEffectView.effect = UIBlurEffect(style: .dark)
                }
            }
            blurAnimator.startAnimation()
            runningAnimators.removeAll()
        }
    }
    
    func startInterativeTransition(state: CardState, duration: TimeInterval) {
        if runningAnimators.isEmpty {
            // run animators
            transitionIfNeeded(state: state, duration: duration)
        }
        
        for animator in runningAnimators {
            animator.pauseAnimation()
            animatorProgressWhenInterupted = animator.fractionComplete
        }
    }
    
    func updateInteractiveTransition(fractionCompleted: CGFloat) {
        for animator in runningAnimators {
            animator.fractionComplete = fractionCompleted + animatorProgressWhenInterupted
        }
    }
    
    func continueInteractiveTransition() {
        for animator in runningAnimators {
            animator.continueAnimation(withTimingParameters: nil, durationFactor: 0)
        }
    }
    
    
}

