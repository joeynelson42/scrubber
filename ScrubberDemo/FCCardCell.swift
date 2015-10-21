//
//  FCCardCell.swift
//  ScrubberDemo
//
//  Created by Joey on 10/21/15.
//  Copyright © 2015 jedmondn. All rights reserved.
//

import AVFoundation
import Foundation
import UIKit

class FCCardCell: UIView, UIGestureRecognizerDelegate {
    var imageView = UIImageView()
    var markedButton = UIButton()
    var editButton = UIButton()
    var mainLabel = UILabel()
    var secondaryLabel = UILabel()
    var bothGradient = UIView()
    var hideNativeLanguage = false
    weak var parentVC: FullscreenViewController!
    var audioPlayer: AVAudioPlayer!
    var card: Card!
//    let threeColumn = NSUserDefaults.standardUserDefaults().valueForKey("showRomanization") as! Bool
    var showingBoth = false
    var autoPlay = false
    
    
    
    enum LanguageVisible{
        case Native
        case Foreign
        case Both
    }
    
    var languageVisible = LanguageVisible.Native
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.addSubview(imageView)
        self.addSubview(mainLabel)
        self.addSubview(bothGradient)
        self.addSubview(secondaryLabel)
        
        let tapGesture = UITapGestureRecognizer(target: self, action: "flipCard:")
        tapGesture.delegate = self
        self.addGestureRecognizer(tapGesture)
        
        self.addSubview(markedButton)
        self.addSubview(editButton)
        
        self.layer.cornerRadius = 5.0
        self.layer.borderWidth = 0.5
        self.layer.borderColor = CGColor.fromHex(0xC1C1C1, alpha: 1.0)
        
        
        imageView.frame = self.frame
        imageView.constrainUsing(constraints: [
            .BottomToBottom : (of: self, offset: 0),
            .TopToTop : (of: self, offset: 0),
            .LeftToLeft : (of: self, offset: 0),
            .RightToRight : (of: self, offset: 0)])
        
        
        //        if card.marked == 0{
        //            markedButton.setImage(UIImage(named: "star"), forState: .Normal)
        //        }
        //        else{
        //            markedButton.setImage(UIImage(named: "greenStar"), forState: .Normal)
        //        }
        markedButton.addTarget(self, action: "toggleMarked:", forControlEvents: .TouchUpInside)
        markedButton.contentMode = UIViewContentMode.Center
        markedButton.constrainUsing(constraints: [
            .TopToTop : (of: self, offset: 25),
            .LeftToLeft : (of: self, offset: 25),
            .Width : (of: self.markedButton, offset: 28),
            .Height : (of: self.markedButton, offset: 28)])
        
        editButton.setImage(UIImage(named: "edit_icon_gray.png"), forState: .Normal)
        editButton.contentMode = UIViewContentMode.Center
        editButton.constrainUsing(constraints: [
            .TopToTop : (of: self, offset: 20),
            .RightToRight : (of: self, offset: -20),
            .Width : (of: self.editButton, offset: 28),
            .Height : (of: self.editButton, offset: 28)])
        
        mainLabel.constrainUsing(constraints: [
            .CenterXToCenterX : (of: self, offset: 0),
            .CenterYToCenterY : (of: self, offset: 0),
            .Width : (of: self, offset: -20),
            .Height : (of: self, offset: 100)])
        mainLabel.textAlignment = .Center
        mainLabel.font = UIFont(name: "OpenSans-Semibold", size: 50)
        mainLabel.textColor = UIColor(red:0.51, green:0.51, blue:0.51, alpha:1)
        mainLabel.lineBreakMode = .ByWordWrapping
        mainLabel.numberOfLines = 2
        
        secondaryLabel.constrainUsing(constraints: [
            .CenterXToCenterX : (of: self, offset: 0),
            .CenterYToCenterY : (of: self, offset: 0),
            .Width : (of: self, offset: -20),
            .Height : (of: self, offset: 100)])
        secondaryLabel.textAlignment = .Center
        secondaryLabel.font = UIFont(name: "OpenSans-Semibold", size: 50)
        secondaryLabel.textColor = UIColor(red:0.51, green:0.51, blue:0.51, alpha:1)
        secondaryLabel.lineBreakMode = .ByWordWrapping
        secondaryLabel.numberOfLines = 2
        secondaryLabel.transform = CGAffineTransformMakeTranslation(0, self.frame.height/4)
        
        bothGradient.constrainUsing(constraints: [
            .LeftToLeft: (of: self, offset: 0),
            .RightToRight : (of: self, offset: 0),
            .TopToTop : (of: self, offset: self.frame.height/2),
            .Height : (of: self, offset: self.frame.height/2)])
        bothGradient.backgroundColor = UIColor(red:0.98, green:0.98, blue:0.99, alpha:1)
        bothGradient.alpha = 0.0
        
        self.clipsToBounds = true
        
//        if card.isPhrase.boolValue {
            mainLabel.font = UIFont(name: "OpenSans-Semibold", size: 25)
            secondaryLabel.font = UIFont(name: "OpenSans-Semibold", size: 25)
//        }
        
    }
    
    func setSingleLanguage() {
        mainLabel.transform = CGAffineTransformMakeTranslation(0, 0)
        secondaryLabel.alpha = 0.0
        bothGradient.alpha = 0.0
        showingBoth = false
    }
    
    func setBothLanguage() {
//        if !showingBoth {
//            mainLabel.transform = CGAffineTransformMakeTranslation(0, -self.frame.height/4)
//            
//            if let symbol = card.symbol where NSUserDefaults.standardUserDefaults().valueForKey("showRomanization") as! Bool {
//                let threeColumnView = ThreeColumnView()
//                threeColumnView.frame = self.frame
//                threeColumnView.symbols = card.translation
//                threeColumnView.romanized = symbol
//                self.addSubview(threeColumnView)
//                threeColumnView.constrainUsing(constraints: [
//                    Constraint.TopToTop : (of: self, multiplier: 1.0, offset: self.frame.height/2),
//                    Constraint.LeftToLeft : (of: self, multiplier: 1.0, offset: 0.0),
//                    Constraint.RightToRight : (of: self, multiplier: 1.0, offset: 0.0),
//                    Constraint.BottomToBottom : (of: self, multiplier: 1.0, offset: 0.0)])
//                threeColumnView.backgroundColor = UIColor.fromHex(0xF6F6F6)
//                self.secondaryLabel.text = ""
//            } else {
//                self.secondaryLabel.text = card.translation
//            }
//            
//            secondaryLabel.alpha = 1.0
//            bothGradient.alpha = 1.0
//            showingBoth = true
//        }
    }
    
    func toggleMarked(sender: AnyObject){
        //        card.markCard()
        //        if card.marked == 0{
        //            markedButton.setImage(UIImage(named: "star"), forState: .Normal)
        //        }
        //        else{
        //            markedButton.setImage(UIImage(named: "greenStar"), forState: .Normal)
        //        }
    }
    
    func flipCard(sender: UIGestureRecognizer) {
        
        if self.languageVisible != .Both {
            print(self.frame.width)
            print(self.mainLabel.frame.width)
            
            
            if self.languageVisible == .Both {   //both isn't implemented yet
                self.languageVisible = .Native
            }
            
            if(self.languageVisible == .Foreign) {
                UIView.transitionWithView(self, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {}, completion: nil)
                if hideNativeLanguage == true {
                    self.mainLabel.text = ""
                }
                else {
                    self.mainLabel.text = self.card.word
                    self.removeRomanizedView()
                }
                self.languageVisible = .Native
            }
            else if(self.languageVisible == .Native) {
                
                if NSUserDefaults.standardUserDefaults().valueForKey("autoAudio") as? Bool ?? true {
                    UIView.transitionWithView(self, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {}, completion: { (Bool) -> Void in
                        self.playCellAudio()
                    })
                }
                else{
                    UIView.transitionWithView(self, duration: 0.5, options: UIViewAnimationOptions.TransitionFlipFromBottom, animations: {}, completion: nil)
                }
                
//                if let symbol = card.symbol where NSUserDefaults.standardUserDefaults().valueForKey("showRomanization") as! Bool {
//                    let threeColumnView = ThreeColumnView()
//                    threeColumnView.frame = self.frame
//                    threeColumnView.symbols = card.translation
//                    threeColumnView.romanized = symbol
//                    self.addSubview(threeColumnView)
//                    threeColumnView.constrainUsing(constraints: [
//                        Constraint.TopToTop : (of: self, multiplier: 1.0, offset: 0.0),
//                        Constraint.LeftToLeft : (of: self, multiplier: 1.0, offset: 0.0),
//                        Constraint.RightToRight : (of: self, multiplier: 1.0, offset: 0.0),
//                        Constraint.BottomToBottom : (of: self, multiplier: 1.0, offset: 0.0)])
//                    threeColumnView.backgroundColor = UIColor.fromHex(0xF6F6F6)
//                    self.mainLabel.text = ""
//                } else {
                    self.mainLabel.text = self.card.translation
//                }
                
                self.languageVisible = .Foreign
            }
        }
    }
    
    func updateCard(hideNative: Bool, showImage: Bool){
        hideNativeLanguage = hideNative
        
        switch parentVC.langVisible{
        case .Foreign:
            self.languageVisible = .Foreign
            removeRomanizedView()
        case .Both:
            self.languageVisible = .Both
        case .Native:
            self.languageVisible = .Native
            removeRomanizedView()
        }
        
        
        if hideNative == true && self.languageVisible == .Native{
            self.mainLabel.text = ""
        }
        else if self.languageVisible == .Native {
            self.mainLabel.text = self.card.word
            self.setSingleLanguage()
        }
        else if self.languageVisible == .Foreign {
            
//            if let symbol = card.symbol where NSUserDefaults.standardUserDefaults().valueForKey("showRomanization") as! Bool {
//                let threeColumnView = ThreeColumnView()
//                threeColumnView.frame = self.frame
//                threeColumnView.symbols = card.translation
//                threeColumnView.romanized = symbol
//                self.addSubview(threeColumnView)
//                threeColumnView.constrainUsing(constraints: [
//                    Constraint.TopToTop : (of: self, multiplier: 1.0, offset: 0.0),
//                    Constraint.LeftToLeft : (of: self, multiplier: 1.0, offset: 0.0),
//                    Constraint.RightToRight : (of: self, multiplier: 1.0, offset: 0.0),
//                    Constraint.BottomToBottom : (of: self, multiplier: 1.0, offset: 0.0)])
//                threeColumnView.backgroundColor = UIColor.fromHex(0xF6F6F6)
//                self.mainLabel.text = ""
//            } else {
                self.mainLabel.text = self.card.translation
//            }
            
            self.setSingleLanguage()
        } else {
            self.mainLabel.text = self.card.word
            self.setBothLanguage()
        }
        
        if showImage == true{
            self.imageView.alpha = 1.0
        }
        else{
            self.imageView.alpha = 0.0
        }
    }
    
    func removeRomanizedView() {
//        for sub in self.subviews {
//            if sub.isKindOfClass(ThreeColumnView) {
//                sub.removeFromSuperview()
//            }
//        }
    }
    
    func playCellAudio() {
        
//        let directory = (UIApplication.sharedApplication().delegate as! AppDelegate).applicationDocumentsDirectory
//        do {
//            print(directory.URLByAppendingPathComponent(self.card.toAudios.localUrl))
//            audioPlayer = try AVAudioPlayer(contentsOfURL: directory.URLByAppendingPathComponent(self.card.toAudios.localUrl))
//        } catch {
//            print(error)
//            audioPlayer = nil
//            return
//        }
//        
//        
//        AudioManagerSharedInstance.playAudio(directory.URLByAppendingPathComponent(self.card.toAudios.localUrl))
//        
//        print("Playing sound: \(self.card.toAudios.localUrl)")
        
    }
    
    @IBAction func playAudioButtonAction(sender: AnyObject) {
        playCellAudio()
    }
}