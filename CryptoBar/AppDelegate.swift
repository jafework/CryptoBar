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
    
    var prices:[String:Double] = [:]
    
    let tickers:[String:String] = [
        "live_trades_ethusd":"ETH",
        "live_trades":"BTC"
    ]
    
    let kPusherKey = "de504dc5763aeef9ff52"
    var pusher:Pusher? = nil
    var channels:[PusherChannel?] = []
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        
        statusItem = NSStatusBar.system.statusItem(withLength:240)
        if let statusItem = statusItem {
            
            let menu = NSMenu()
            
            menu.addItem(NSMenuItem(title: "Quit", action: #selector(NSApplication.terminate(_:)), keyEquivalent: "q"))
            
            statusItem.menu = menu
        }
        
        pusher = Pusher(key: kPusherKey)
        
        tickers.forEach { (ticker, value) in
            let channel = pusher?.subscribe(channelName: ticker)
            channel?.bind(eventName: "trade", callback:{ data in
                if let result:[String:AnyObject] = data as? Dictionary {
                    if let value:Double = result["price"] as? Double {
                        self.prices[ticker] = value
                        self.updateMenu()
                    }
                }
            })
            channels.append(channel)
        }
        
        pusher?.connect()
    }
    
    func tickerToName(ticker:String) -> String{
        var name = ""
        if let value:String = tickers[ticker] {
            name = value
        }
        return name
    }
    
    func updateMenu() {
        if let button = statusItem?.button {
            
            let formatter = NumberFormatter()
            formatter.numberStyle = .currency
            
            var texts:[String] = []
            
            self.prices.forEach({ (key, value) in
                let num:NSNumber = NSNumber(value:value)
                if let price:String = formatter.string(from: num){
                    texts.append("\(tickerToName(ticker: key)) \(price)")
                }
            })
            
            button.title = texts.joined(separator: " | ")
        }
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
}

