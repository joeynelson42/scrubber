//
//  CarouselView.swift
//  ScrubberDemo
//
//  Created by Joey on 10/21/15.
//  Copyright © 2015 jedmondn. All rights reserved.
//

import Foundation
import UIKit

class CarouselView: UIView {
    
    let screenWidth = UIScreen.mainScreen().bounds.width
    let screenHeight = UIScreen.mainScreen().bounds.height
    
    var numCards: Int! = 0
    var cards = [UIView]() // current rendered cards
    let scrollView = UIScrollView()
    let backgroundViewForTap = UIView()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollView.canCancelContentTouches = false
        
        self.addSubview(self.backgroundViewForTap)
        self.backgroundViewForTap.backgroundColor = .clearColor()
        self.backgroundViewForTap.fillSuperview()
        
        self.addSubview(self.scrollView)
        self.scrollView.pagingEnabled = true
        self.scrollView.clipsToBounds = false
        self.scrollView.showsHorizontalScrollIndicator = false
        self.scrollView.backgroundColor = UIColor.clearColor()
        
        self.scrollView.constrainUsing(constraints: [
            .LeftToLeft : (of: self, offset: 20),
            .RightToRight : (of: self, offset: -10),
            .TopToTop : (of: self, offset: -25),
            .BottomToBottom : (of: self, offset: 60)])
        
        // TODO: Might want to add/constrain cards in the view controller
        for (index, card) in self.cards.enumerate() {
            self.scrollView.addSubview(card)
            card.clipsToBounds = true
            
            card.backgroundColor = UIColor.whiteColor()
            if index == 0 {
                card.constrainUsing(constraints: [
                    .LeftToLeft : (of: self.scrollView, offset: 9),
                    .Width : (of: self.scrollView, offset: -30),
                    .CenterYToCenterY : (of: self.scrollView, offset: 0),
                    .Height : (of: self.scrollView, offset: 0)])
            } else {
                card.constrainUsing(constraints: [
                    .LeftToRight : (of: self.cards[index - 1], offset: 30),
                    .Width : (of: self.cards[0], offset: 0),
                    .CenterYToCenterY : (of: self.cards[0], offset: 0),
                    .Height : (of: self.cards[0], offset: 0)])
            }
            
            card.layer.shadowColor = UIColor.blackColor().CGColor
            card.layer.shadowOffset = CGSizeMake(0, 2)
            card.layer.shadowRadius = 1
            card.layer.shadowOpacity = 0.13
            card.layer.masksToBounds = false
        }
        
        let contentWidth = CGFloat(CGFloat(cards.count) * (self.bounds.size.width - 30))
        self.scrollView.contentSize = CGSize(width: contentWidth, height: scrollView.frame.height)
    }
}