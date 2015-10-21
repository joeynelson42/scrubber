//
//  CarouselViewController.swift
//  ScrubberDemo
//
//  Created by Clay Ellis on 6/6/15.
//  Copyright (c) 2015 Appsidian. All rights reserved.
//

import Foundation
import UIKit

protocol CarouselDelegate {
    func willDismissCarousel()
    
    // Delegate functions for reusable cards
    func numberOfCardsInCarousel() -> Int
    func carouselCardAtIndex(index index: Int) -> UIView
}

class CarouselViewController: UIViewController, UIScrollViewDelegate {
    
    var carouselView = CarouselView()
    var delegate: CarouselDelegate?
    let tapRecognizer = UITapGestureRecognizer()
    var allowDismissCarousel = false
    
    var currentVisibleCard = 0
    
    init() {
        super.init(nibName: nil, bundle: nil)
        self.modalPresentationStyle = .Custom
        self.allowDismissCarousel = false
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = self.carouselView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.carouselView.backgroundViewForTap.addGestureRecognizer(self.tapRecognizer)
        self.tapRecognizer.addTarget(self, action: "dismissCarousel")
        
        self.carouselView.scrollView.delegate = self
        self.carouselView.numCards = self.delegate?.numberOfCardsInCarousel()
        var carouselCards = [UIView]()
        for index in 0..<self.carouselView.numCards {
            // Pre-loads first 5 cards for fast loading
            if index < 5 {
                if let card = self.delegate?.carouselCardAtIndex(index: index) {
                    carouselCards.append(card)
                }
            }
        }
        self.carouselView.cards = carouselCards
        // TODO: Animate cards in
    }
    
    // TEMPORARY HACK: Loads and renders ALL the rest of the cards after view has appeared
    // This causes lag and uses lots memory for large numbers of cards (>50)
    // TODO: Implement reusable cards instead
    override func viewDidAppear(animated: Bool) {
        if self.carouselView.numCards > 5 {
            var carouselCards = [UIView]()
            for index in 5..<self.carouselView.numCards {
                if let card = self.delegate?.carouselCardAtIndex(index: index) {
                    carouselCards.append(card)
                }
            }
            self.carouselView.cards += carouselCards
            self.carouselView.setNeedsLayout()
        }
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        // TODO: Implement reusable cards here
        let offset = scrollView.contentOffset.x
        let currentCard = Int(ceil(offset / self.carouselView.frame.width))
        if currentCard != self.currentVisibleCard {
            self.currentVisibleCard = currentCard
        }
    }
    
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if(scrollView == self.carouselView.scrollView){
            let cardCellSize = (parentViewController as! FullscreenViewController).cardCellSize
            let scrubCellSize = (parentViewController as! FullscreenViewController).scrubberCellSize
            let scalar = cardCellSize.width/scrubCellSize.width
            (parentViewController as! FullscreenViewController).scrubberCollectionView.setContentOffset(CGPointMake(scrollView.contentOffset.x / scalar, scrollView.contentOffset.y), animated: false)
        }
    }
    
    func scrollViewWillEndDragging(scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        (parentViewController as! FullscreenViewController).updateCards() //this will update the card back to the current initial language after scrolling
    }
    
    func dismissCarousel() {
        if self.allowDismissCarousel {
            self.delegate!.willDismissCarousel()
            UIView.animateWithDuration(0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0, options: UIViewAnimationOptions.CurveLinear, animations: {
                }) { (done: Bool) -> Void in
                    self.dismissViewControllerAnimated(false, completion: { () -> Void in
                        
                    })
            }
        }
    }
}


