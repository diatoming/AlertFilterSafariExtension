//
//  SafariExtensionHandler.swift
//  AlertFilter
//
//  Created by Diatoming on 12/20/17.
//  Copyright © 2017 diatoming.com. All rights reserved.
//

import SafariServices

enum DefaultsKey: String {
    case schemeList
    case autoBackToSafari
}

enum JSMessage: String {
    case docLoaded
    case handleCustomScheme
}

enum DispatchMessage: String {
    case extensionSettingsUpdated
}

class SafariExtensionHandler: SFSafariExtensionHandler {

    
    override func messageReceived(withName messageName: String, from page: SFSafariPage, userInfo: [String : Any]?) {
        // This method will be called when a content script provided by your extension calls safari.extension.dispatchMessage("message").
        page.getPropertiesWithCompletionHandler { properties in
            NSLog("The extension received a message (\(messageName)) from a script injected into (\(String(describing: properties?.url))) with userInfo (\(userInfo ?? [:]))")
            
            guard let name = JSMessage(rawValue: messageName) else {
                fatalError("Need to handle this message: \(messageName)")
            }
            
            switch name {
            case .docLoaded:
                // after DOM loaded, send scheme list to JS side
                let settings: [String: [String]] = [DefaultsKey.schemeList.rawValue: Array(SafariExtensionViewController.shared.schemeList)]
                page.dispatchMessageToScript(withName: DispatchMessage.extensionSettingsUpdated.rawValue, userInfo: settings)
                
            case .handleCustomScheme:
                
                if let info = userInfo, let urlString = info["url"] as? String, let url = URL(string: urlString) {
                    NSWorkspace.shared.open(url)
                    
                    guard UserDefaults.standard.bool(forKey: DefaultsKey.autoBackToSafari.rawValue) else { return }
                    let safari = NSWorkspace.shared.runningApplications.filter {
                        $0.bundleIdentifier == "com.apple.Safari"
                    }.first
                    DispatchQueue.global().asyncAfter(deadline: .now() + 0.3, execute: {
                        safari?.activate(options: .activateIgnoringOtherApps)
                    })
                }
            
            }
            
        }
        
    }
    
    override func popoverViewController() -> SFSafariExtensionViewController {
        return SafariExtensionViewController.shared
    }

}
