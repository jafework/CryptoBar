//
//  AppDelegate.swift
//  CryptoBar
//
//  Created by Joseph Afework on 1/8/18.
//  Copyright © 2018 Joseph Afework. All rights reserved.
//

import Cocoa
import PusherSwift

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var statusItem:NSStatusItem?
    
    var eth:Double = 0
    var btc:Double = 0
    
    var prices:[String:Double] = [:]
    
    var pusher:Pusher? = nil
    var chan:PusherChannel? = nil
    var chan2:PusherChannel? = nil
    
    var channels:[PusherChannel?] = []
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        statusItem = NSStatusBar.system.statusItem(withLength:240)
        if let statusItem = statusItem {
            
            let menu = NSMenu()
            
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            
            statusItem.menu = menu
        }
        
        pusher = Pusher(key: "de504dc5763aeef9ff52")
        
        chan = pusher?.subscribe(channelName: "live_trades_ethusd")
        chan?.bind(eventName: "trade", callback: { data in
            
            if let result:[String:AnyObject] = data as? Dictionary {
                let value:Double = result["price"] as! Double
                self.eth = value
                
                self.updateMenu()
            }
            
            print("\(String(describing: data))")
        })
        
        chan2 = pusher?.subscribe(channelName: "live_trades")
        
        chan2?.bind(eventName: "trade", callback: { data in
            
            if let result:[String:AnyObject] = data as? Dictionary {
                let value:Double = result["price"] as! Double
                self.btc = value
                
                self.updateMenu()
            }
            
            print("\(String(describing: data))")
        })
        
        pusher?.connect()
    }
    
    func BuildChannel(code:String, name:String, callback:(@escaping (Any?) -> (Void))) -> PusherChannel? {
        let channel = pusher?.subscribe(channelName: name)
        channel?.bind(eventName: "trade", callback: callback)
        return channel
    }
    
    func updateMenu() {
        if let button = statusItem?.button {
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            
            let eth:String? = formatter.string(from: NSNumber(value:self.eth))
            let btc:String? = formatter.string(from: NSNumber(value:self.btc))
            
            if let eth = eth, let btc = btc {
                button.title = "BTC \(btc) | ETH \(eth)"
            }
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

