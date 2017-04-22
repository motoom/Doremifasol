
//  AppDelegate.swift

import UIKit

var sampler: MidiSampler?

var rootnote = 60
var rootvar = true
var register = 1 // 0/1/2: 0=bass, 1=middle, 2=treble
var patch = 0 // 0...127: 0=piano, 73=flute, etc...
var ascending = true
var descending = true
var separate = false // false: sound both notes at the same time
var timebetween = 2
var timethink = 2
var speaking = true
var intervals = [4, 7]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        intervals = defaults.objectForKey("intervals") as? [Int] ?? []
        return true
        }

    func applicationWillTerminate(application: UIApplication) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(intervals, forKey: "intervals")
        }


    }

