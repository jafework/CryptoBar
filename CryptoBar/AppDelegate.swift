//
//  AppDelegate.swift
//  CryptoBar
//
//  Created by Joseph Afework on 1/8/18.
//  Copyright © 2018 Joseph Afework. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem:NSStatusItem?
    var timer:Timer?
    
    var eth:Int = 0
    var btc:Int = 0
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(AppDelegate.refresh(_:)), userInfo: nil, repeats: true)
        if let timer = timer {
            RunLoop.main.add(timer, forMode: RunLoopMode.commonModes)
        }
        
        statusItem = NSStatusBar.system.statusItem(withLength:180)
        if let statusItem = statusItem {
            
            let menu = NSMenu()
            
            menu.addItem(NSMenuItem(title: "Refresh", action: #selector(AppDelegate.refresh(_:)), keyEquivalent: "r"))
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "Quit Quotes", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            
            statusItem.menu = menu
        }
        
        refresh(nil)
    }
    
    @objc func refresh(_ sender: Any?) {
        let quoteText = "Never put off until tomorrow what you can do the day after tomorrow."
        let quoteAuthor = "Mark Twain"
        
        print("\(quoteText) — \(quoteAuthor)")
        
        updateMenu()
    }
    
    func updateMenu() {
        if let button = statusItem?.button {
            button.action = #selector(refresh(_:))
            button.title = "BTC \(btc) | ETH \(eth)"
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }


}

