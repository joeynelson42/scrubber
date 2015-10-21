//
//  FullscreenViewController.swift
//  ScrubberDemo
//
//  Created by Joey on 10/21/15.
//  Copyright © 2015 jedmondn. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation
import CoreData

class FullscreenViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var scrubberCollectionView: UICollectionView!
    @IBOutlet weak var toolbarContainer: UIView!
    @IBOutlet weak var scrubberButton: UIButton!
    @IBOutlet weak var scrubberSelectedBorder: UIImageView!
    @IBOutlet weak var returnToCardVCButton: UIButton!
    
//    var initialScrollView: UIScrollView!
    var currentIndexPath: NSIndexPath!
    var cardCellSize: CGSize!
    var scrubberCellSize: CGSize!
    var cards = [Card]()
    var cardViews = [UIView]()
    var shuffledCards = [Card]()
    let mainStoryboard = UIStoryboard(name: "Main", bundle: NSBundle.mainBundle())
    var scrollPage: Int = 1
    
    //options
    var autoPlayAudio = true
    var showImages = true
    var hideNativeTextOnImage = false
    enum LanguageVisible{
        case Both, Foreign, Native
    }
    var langVisible: LanguageVisible = .Native
    
    var cardCarousel: CarouselViewController!
    
    
    override func viewDidLoad() {
        loadDummyCards()
        
        filterUpdate()
        
        self.scrubberCollectionView.hidden = true
        
        // loadCellSizes()
    }
    
    override func viewDidAppear(animated: Bool) {
        loadCellSizes()
        
        let path = NSIndexPath(forRow: scrollPage, inSection: 0)
        self.scrubberCollectionView.scrollToItemAtIndexPath(path, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: false)
        
    }
    
    func loadDummyCards(){
        for _ in 1...10{
            let newCard = Card(from: "hello", to: "hejsan")
            cards.append(newCard)
        }
    }
    
    func removeCarousel(){
        let vc = self.childViewControllers.last as! CarouselViewController
        vc.willMoveToParentViewController(self)
        vc.carouselView.removeFromSuperview()
        vc.removeFromParentViewController()
    }
    
    func loadCarousel(){
        self.cardCarousel = CarouselViewController()
        self.cardCarousel.carouselView.cards = cardViews
        self.addChildViewController(cardCarousel)
        self.view.addSubview(cardCarousel.carouselView)
        self.view.sendSubviewToBack(cardCarousel.carouselView)
        self.cardCarousel.carouselView.constrainUsing(constraints: [
            .Width : (of: self.view, offset: -60),
            .CenterXToCenterX : (of: self.view, offset: 0),
            .TopToTop : (of: self.view, offset: 120),
            .BottomToBottom : (of: self.view, offset: -125)])
        
        self.cardCarousel.didMoveToParentViewController(self)
        self.cardCarousel.carouselView.backgroundColor = UIColor.clearColor()
        self.cardCarousel.carouselView.scrollView.delegate = cardCarousel
        self.cardCarousel.carouselView.scrollView.canCancelContentTouches = false
    }
    
    func loadCardsIntoView(){
        if cardViews.count > 0{
            cardViews.removeAll(keepCapacity: false)
        }
        
        for (index,card) in cards.enumerate(){
            let newView = FCCardCell()
            newView.tag = index + 1
            newView.card = card
            newView.parentVC = self
            newView.mainLabel.frame = newView.frame
            
            if hideNativeTextOnImage == true {
                newView.mainLabel.text = ""
            }
            else{
                if langVisible == .Native {
                    newView.mainLabel.text = newView.card.word
                }
                else if langVisible == .Foreign{
                    newView.mainLabel.text = newView.card.translation
                } else {
                    newView.mainLabel.text = "\(newView.card.word)\n\n\(newView.card.translation)"
                }
            }
            
            if !showImages{
                newView.imageView.alpha = 0.0
            }
            
            //            if let imageString = card.image {
            //                let imageURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.com.MTC.TALL-Planning")?.path?.stringByAppendingString("/\(imageString)").stringByAppendingString(".jpeg")
            //                let image = UIImage(contentsOfFile: imageURL!)
            //                newView.imageView.contentMode = UIViewContentMode.ScaleAspectFill
            //                print(image!.imageOrientation.rawValue)
            //                newView.imageView.image = image
            //            }
            
            
//            let audioURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.com.MTC.TALL-Planning")?.path?.stringByAppendingString("/\(card.toAudio)").stringByAppendingString(".m4a")
//            _ = try? AVAudioPlayer(contentsOfURL: NSURL(string: audioURL!)!)
            
            
            newView.layer.masksToBounds = true
            newView.imageView.layer.masksToBounds = true
            newView.layer.cornerRadius = 5.0
            newView.imageView.layer.cornerRadius = 5.0
            
            newView.userInteractionEnabled = true
            newView.markedButton.userInteractionEnabled = true
            cardViews.append(newView)
        }
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        let newScrubLayout = FCScrubberFlowLayout()
        newScrubLayout.awakeFromNib()
        scrubberCollectionView.setCollectionViewLayout(newScrubLayout, animated: true)
        loadCellSizes()
    }
    
    @IBAction func returnToDeckAction(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
//    @IBAction func optionsButtonAction(sender: AnyObject) {
//        let popoverContent = mainStoryboard.instantiateViewControllerWithIdentifier("OptionsPopover") as! OptionsPopoverViewController
//        popoverContent.modalPresentationStyle = UIModalPresentationStyle.Popover
//        let popover = popoverContent.popoverPresentationController
//        popoverContent.preferredContentSize = CGSizeMake(338, 222)
//        popover?.delegate = self
//        popover?.sourceView = self.view
//        popoverContent.parentVC = self
//        
//        let viewCenter = self.view.center
//        popover?.sourceRect = CGRectMake(viewCenter.x, viewCenter.y, 0, 0)
//        popover?.permittedArrowDirections = UIPopoverArrowDirection()
//        
//        self.presentViewController(popoverContent, animated: true, completion: nil)
//        
//        popoverContent.autoPlayAudioSwitch.setOn(self.autoPlayAudio, animated: false)
//        //        popoverContent.showImagesSwitch.setOn(self.showImages, animated: false)
//        //        popoverContent.hideNativeSwitch.setOn(self.hideNativeTextOnImage, animated: false)
//    }
    
    @IBAction func scrubberToggleButton(sender: AnyObject) {
        if scrubberCollectionView.hidden == true{
            scrubberCollectionView.hidden = false
            scrubberSelectedBorder.alpha = 0.0
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.scrubberCollectionView.transform = CGAffineTransformMakeTranslation(0, -80)
                self.scrubberSelectedBorder.transform = CGAffineTransformMakeTranslation(0, -80)
                self.scrubberSelectedBorder.alpha = 1.0
                self.scrubberButton.backgroundColor = UIColor(red:0.27, green:0.59, blue:0.96, alpha:1)
                self.scrubberButton.setTitleColor(UIColor.whiteColor(), forState: .Normal)
                self.scrubberButton.layer.borderWidth = 0
                
                self.cardCarousel.carouselView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(0.9, 0.9), CGAffineTransformMakeTranslation(0, -30))
                
                }, completion: { finished in
                    
            })
        }
        else{
            UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
                self.scrubberCollectionView.transform = CGAffineTransformMakeTranslation(0, 0)
                self.scrubberSelectedBorder.transform = CGAffineTransformMakeTranslation(0, 0)
                self.scrubberSelectedBorder.alpha = 0.0
                
                self.scrubberButton.backgroundColor = UIColor.whiteColor()
                self.scrubberButton.setTitleColor(UIColor(red:0.27, green:0.59, blue:0.96, alpha:1), forState: .Normal)
                self.scrubberButton.layer.borderWidth = 1
                
                self.cardCarousel.carouselView.transform = CGAffineTransformConcat(CGAffineTransformMakeScale(1.0, 1.0), CGAffineTransformMakeTranslation(0, 0))
                }, completion: { finished in
                    self.scrubberCollectionView.hidden = true
            })
        }
        
    }
    
    @IBAction func shuffleButtonPressed(sender: AnyObject) {
        for var i = 0; i < cards.count; i++ {
            let randomNumber = Int(arc4random_uniform(UInt32(cards.count)))
            if i != randomNumber {
                swap(&cards[i], &cards[randomNumber])
            }
        }
        scrollPage = 1
        reloadCarousel()
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return cards.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let cell = scrubberCollectionView.dequeueReusableCellWithReuseIdentifier("scrubberCell", forIndexPath: indexPath) as! FCScrubberViewCell
        
        if(langVisible == LanguageVisible.Native || langVisible == LanguageVisible.Both){
            cell.centerLabel.text = cards[indexPath.row].word
        }
        else if(langVisible == LanguageVisible.Foreign){
            cell.centerLabel.text = cards[indexPath.row].translation
        }
        
        
        cell.centerLabel.font = UIFont(name: "Open Sans", size: 12)
        cell.centerLabel.lineBreakMode = .ByWordWrapping
        cell.centerLabel.numberOfLines = 3
        cell.centerLabel.preferredMaxLayoutWidth = 115
        cell.centerLabel.clipsToBounds = true
        cell.scrubberImageView.image = nil
        
        
        
        //        if let imageString = cards[indexPath.row].image {
        //            let imageURL = NSFileManager.defaultManager().containerURLForSecurityApplicationGroupIdentifier("group.com.MTC.TALL-Planning")?.path?.stringByAppendingString("/\(imageString)").stringByAppendingString(".jpeg")
        //            let image = UIImage(contentsOfFile: imageURL!)
        //            cell.scrubberImageView.image = image
        //        }
        
        if let _ = cell.scrubberImageView.image{
            cell.centerLabel.textColor = UIColor.whiteColor()
        }
        else{
            cell.centerLabel.textColor = UIColor.flashcardsBlue()
        }
        
        return cell
    }
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        scrollPage = Int(round(self.scrubberCollectionView.contentOffset.x/126)) + 1
        self.scrubberButton.setTitle("\(scrollPage)/\(cards.count)", forState: .Normal)
        
        if(scrollView == scrubberCollectionView) {
            let scalar: CGFloat = scrubberCellSize.width/cardCellSize.width
            self.cardCarousel.carouselView.scrollView.setContentOffset(CGPointMake(self.scrubberCollectionView.contentOffset.x / scalar, self.scrubberCollectionView.contentOffset.y), animated: false)
        }
    }
    
    func scrollViewWillBeginDragging(scrollView: UIScrollView) {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.scrubberSelectedBorder.alpha = 0.2
            
            }, completion: { finished in
                
        })
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        UIView.animateWithDuration(0.5, delay: 0.0, usingSpringWithDamping: 1.0, initialSpringVelocity: 3, options: UIViewAnimationOptions.CurveEaseInOut, animations: { () -> Void in
            self.scrubberSelectedBorder.alpha = 1.0
            
            }, completion: { finished in
                
        })
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        scrubberCollectionView.scrollToItemAtIndexPath(indexPath, atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
        
        let cell = collectionView.cellForItemAtIndexPath(indexPath) as! FCScrubberViewCell
        
        print(cell.frame.width)
        print(cell.centerLabel.frame.width)
    }
    
    func loadCellSizes() {
        let scrubInset: CGFloat = 10
        cardCellSize = CGSizeMake(self.cardCarousel.carouselView.bounds.width + 37, self.cardCarousel.carouselView.scrollView.frame.height)
        let scrubLayout = FCScrubberFlowLayout()
        scrubLayout.awakeFromNib()
        scrubberCellSize = CGSizeMake(scrubLayout.itemSize.width + scrubInset, scrubLayout.itemSize.height)
    }
    
    func filterUpdate(){
        
//        switch parentVC.filterState{
//        case .Both:
//            cards = deck.getAllTranslations()
//        case .Marked:
//            cards = deck.getAllTranslations()
//        case .Unmarked:
//            cards = deck.getAllTranslations()
//        }
        
        reloadCarousel()
    }
    
    func reloadCarousel(){
        if let _ = cardCarousel{
            removeCarousel()
        }
        
        loadCardsIntoView()
        loadCarousel()
        scrubberCollectionView.reloadData()
        
        if scrollPage == 0{
            self.scrubberButton.setTitle("1/\(cards.count)", forState: .Normal)
        }
        else{
            self.scrubberButton.setTitle("\(scrollPage)/\(cards.count)", forState: .Normal)
        }
        
    }
    
    func updateCards(){
        for view in cardCarousel.carouselView.scrollView.subviews {
            if view.isKindOfClass(FCCardCell) {
                
                (view as! FCCardCell).updateCard(hideNativeTextOnImage, showImage: showImages)
            }
        }
        scrubberCollectionView.reloadData()
    }
    
}








class Card{
    var word: String!
    var translation: String!
    
    init(from: String, to: String){
        word = from
        translation = to
    }
}







