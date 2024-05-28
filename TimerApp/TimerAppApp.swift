//
//  TimerAppApp.swift
//  TimerApp
//
//  Created by Turner Trowbridge on 5/28/24.
//

import SwiftUI

@main
struct TimerApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var statusBar: NSStatusBar?
    var statusItem: NSStatusItem?
    var popover: NSPopover?
    var timerView: NSView?

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusBar = NSStatusBar.system
        statusItem = statusBar?.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem?.button {
            button.image = NSImage(systemSymbolName: "timer", accessibilityDescription: nil)
            button.action = #selector(togglePopover(_:))
        }

        popover = NSPopover()
        popover?.contentViewController = NSViewController()
        popover?.contentViewController?.view = NSHostingView(rootView: ContentView())
    }

    @objc func togglePopover(_ sender: AnyObject?) {
        if popover?.isShown == true {
            popover?.performClose(sender)
        } else {
            if let button = statusItem?.button {
                popover?.show(relativeTo: button.bounds, of: button, preferredEdge: NSRectEdge.minY)
            }
        }
    }
}
