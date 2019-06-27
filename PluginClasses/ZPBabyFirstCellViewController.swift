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
        }
    }
    
    //MARK: private
    
    //populates an atomEntry with extensions' parameters
    func populateEntry(with atomEntry: APAtomEntry) {
        
        if atomEntry.entryType == .video {
            // Hide play button
            if  let imageViewCollection = self.imageViewCollection {
                for image in imageViewCollection {
                    if let tmpImage = image as? APImageView {
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
            if self.itemLockedImageView.isHidden == true {
                self.itemLockedImageView.isHidden = false
                ZAAppConnector.sharedInstance().componentsDelegate.customization(for: self.itemLockedImageView,
                                                                                 attributeKey: "cell_play_btn",
                                                                                 attributesDictionary: ["image_name" : "cell_play_btn"],
                                                                                 defaultAttributesDictionary: nil,
                                                                                 componentModel: componentModel,
                                                                                 componentDataSourceModel: componentDataSourceModel,
                                                                                 componentState: .normal)
            }
        }
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
