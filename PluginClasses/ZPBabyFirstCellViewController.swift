//
//  ZPBabyFirstCellViewController.swift
//
//  Created by Miri Vecselboim on
//  Copyright © 2018 Applicaster Ltd. All rights reserved.
//

import Foundation
import UIKit
import ZappGeneralPluginsSDK
import ApplicasterSDK
import ComponentsSDK
import ZappPlugins

class ZPBabyFirstCellViewController : CACellViewController {
    
    var atomEntry:APAtomEntry?
    var atomFeed: APAtomFeed?
    
    override func displayAtomEntry(_ entry: NSObject) {
        if let entry = entry as? APAtomEntry {
            self.atomEntry = entry
        }
        super.displayAtomEntry(entry)
    }
    
    override func updateUI() {
        super.updateUI()
        if let atomEntry = self.atomEntry {
            self.populateEntry(with: atomEntry)
        } else if let atomFeed = self.atomFeed {
            self.populateFeed(with: atomFeed)
        }
    }
    
    override func displayAtomFeed(_ atomFeed: NSObject!) {
        if let atomFeed = atomFeed as? APAtomFeed {
            self.atomFeed = atomFeed
        }
        super.displayAtomFeed(atomFeed)
    }
    
    //MARK: private
    
    //populates an atomEntry with extensions' parameters
    func populateEntry(with atomEntry: APAtomEntry) {
        let type = atomEntry.entryType
        if type == .video {
            // Hide play button
            if  let imageViewCollection = self.imageViewCollection {
                for image in imageViewCollection {
                    if let tmpImage = image as? APImageView, let componentModel = componentModel {
                        ZAAppConnector.sharedInstance().componentsDelegate.customization(for: tmpImage,
                                                                                         attributeKey: "",
                                                                                         attributesDictionary: ["image_name" : ""],
                                                                                         defaultAttributesDictionary: nil,
                                                                                         componentModel: componentModel,
                                                                                         componentDataSourceModel: componentDataSourceModel,
                                                                                         componentState: .normal)
                    }
                }
            }
            
            // Replace the lock asset by a new play button asset
            if self.itemLockedImageView.isHidden == true && !self.shouldPreventUserInteraction(for: atomEntry), let componentModel = componentModel {
                self.itemLockedImageView.isHidden = false
                ZAAppConnector.sharedInstance().componentsDelegate.customization(for: self.itemLockedImageView,
                                                                                 attributeKey: "cell_play_btn",
                                                                                 attributesDictionary: ["image_name" : "cell_play_btn"],
                                                                                 defaultAttributesDictionary: nil,
                                                                                 componentModel: componentModel,
                                                                                 componentDataSourceModel: componentDataSourceModel,
                                                                                 componentState: .normal)
            }
        } else if type == .link {
            self.removeFreeLockIcons()
        }
        if let atomVideoEntry = atomEntry as? APAtomVideoEntry {
            if let downloadButtonContainerView = self.downloadButtonContainerView,
                !downloadButtonContainerView.isHidden {
                downloadButtonContainerView.isUserInteractionEnabled = (atomVideoEntry.isFree() || APApplicasterController.sharedInstance()?.endUserProfile.subscriptionExpirationDate() != nil)
            }
        }
        if self.shouldPreventUserInteraction(for: atomEntry) {
            self.removeCellButtons()
            self.removeFreeLockIcons()
            addHidingView()
        }
    }
    
    func populateFeed(with atomFeed: APAtomFeed) {
        self.removeFreeLockIcons()
        if self.shouldPreventUserInteraction(for: atomFeed) {
            self.removeCellButtons()
            self.addHidingView()
        }
    }
    
    override func prepareComponentForReuse() {
        super.prepareComponentForReuse()
        self.updateUI()
    }
    
    func removeFreeLockIcons() {
        self.itemLockedImageView?.isHidden = true
        self.inAppRibbonImageView?.isHidden = true
    }
    
    func removeCellButtons() {
        self.favoritesButton?.isHidden = true
        self.downloadButton?.isHidden = true
    }
    
    func shouldPreventUserInteraction(for atomEntry:APAtomEntry) -> Bool {
        var retVal = false;
        let unclickableKey = "unClickable"
        retVal = atomEntry.title == unclickableKey || atomEntry.summary == unclickableKey || atomEntry.pipesObject["ui_tag"] as? String == unclickableKey
        return retVal
    }
    
    func shouldPreventUserInteraction(for atomFeed:APAtomFeed) -> Bool {
        var retVal = false;
        let unclickableKey = "unClickable"
        retVal = atomFeed.pipesObject["summary"] as? String == unclickableKey || atomFeed.pipesObject["ui_tag"] as? String == unclickableKey || atomFeed.title == unclickableKey
        return retVal
    }
    
    func addHidingView() {
        let button = UIButton.init(frame: self.view.frame)
        button.backgroundColor = UIColor.clear
        button.isUserInteractionEnabled = true
        self.view.addSubview(button)
    }
    
    func isSubscribed() -> Bool {
        
        var retVal = false
        
        var subscriptionExpirationDate: Date?
        var authorizationTokens:[String : AnyObject]?
        
        if let endUserProfile = APApplicasterController.sharedInstance()?.endUserProfile,
            let expirationDate = endUserProfile.subscriptionExpirationDate() {
            subscriptionExpirationDate = expirationDate
        }
        
        if let tokens = APAuthorizationManager.sharedInstance().authorizationTokens() as? [String : AnyObject] {
            authorizationTokens = tokens
        }
        
        if subscriptionExpirationDate != nil || authorizationTokens != nil {
            retVal = true
        }
        
        return retVal
    }
    
}
