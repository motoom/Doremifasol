
//  AppDelegate.swift

import UIKit

var sampler: MidiSampler?

var rootnote = 60  // Middle C, 261.6Hz
var fixedroot = true
var register = 1 // 0/1/2: 0=bass, 1=middle, 2=treble
var patch = 0 // 0...127: 0=piano, 73=flute, etc...
var ascending = true
var descending = false
var separate = true // false: sound both notes at the same time
var speaking = true
var intervals = [3, 4, 7]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        rootnote = defaults.objectForKey("rootnote") as? Int ?? 60
        fixedroot = defaults.objectForKey("fixedroot") as? Bool ?? true
        register = defaults.objectForKey("register") as? Int ?? 1
        patch = defaults.objectForKey("patch") as? Int ?? 0
        ascending = defaults.objectForKey("ascending") as? Bool ?? true
        descending = defaults.objectForKey("descending") as? Bool ?? false
        separate = defaults.objectForKey("separate") as? Bool ?? true
        speaking = defaults.objectForKey("speaking") as? Bool ?? true
        intervals = defaults.objectForKey("intervals") as? [Int] ?? [3, 4, 7]
        return true
        }

    func applicationWillTerminate(application: UIApplication) {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.setInteger(rootnote, forKey: "rootnote")
        defaults.setBool(fixedroot, forKey: "fixedroot")
        defaults.setInteger(register, forKey: "register")
        defaults.setInteger(patch, forKey: "patch")
        defaults.setBool(ascending, forKey: "ascending")
        defaults.setBool(descending, forKey: "descending")
        defaults.setBool(separate, forKey: "separate")
        defaults.setBool(speaking, forKey: "speaking")
        defaults.setObject(intervals, forKey: "intervals")
        }


    }

