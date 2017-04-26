
//  AppDelegate.swift  31 6 44 83 77 43

import UIKit

var sampler: MidiSampler?

var rootnote = 60  // Middle C, 261.6Hz
var fixedroot = false
var register = 1 // 0/1/2: 0=bass, 1=middle, 2=treble
var patch = 0 // 0...127: 0=piano, 73=flute, etc...
var ascending = true
var descending = true
var separate = true // false: sound both notes at the same time
var speaking = true
var intervals = [3, 4, 7, 12]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var playViewController: PlayViewController?

    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let defaults = NSUserDefaults.standardUserDefaults()
        rootnote = defaults.objectForKey("rootnote") as? Int ?? 60
        fixedroot = defaults.objectForKey("fixedroot") as? Bool ?? false
        register = defaults.objectForKey("register") as? Int ?? 1
        patch = defaults.objectForKey("patch") as? Int ?? 0
        ascending = defaults.objectForKey("ascending") as? Bool ?? true
        descending = defaults.objectForKey("descending") as? Bool ?? true
        separate = defaults.objectForKey("separate") as? Bool ?? true
        speaking = defaults.objectForKey("speaking") as? Bool ?? true
        intervals = defaults.objectForKey("intervals") as? [Int] ?? [3, 4, 7, 12]
        return true
        }

    func save() {
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


    func applicationWillResignActive(application: UIApplication) {
        // Called for example, when incoming call occurs, or user doubleclick home button
        save()
        playViewController?.pause()
        }

    /*
    func applicationDidEnterBackground(application: UIApplication) {
        // Called when the user accepts the incoming call, or switches to the home screen (or another app)
        print("applicationDidEnterBackground")
        }

    func applicationWillTerminate(application: UIApplication) {
        print("applicationWillTerminate")
        }

    func applicationWillEnterForeground(application: UIApplication) {
        print("applicationWillEnterForeground")
        }

    func applicationDidBecomeActive(application: UIApplication) {
        print("applicationDidBecomeActive")
        }
    */

    }


/*
Bij gebeld worden:

AVSpeechSynthesizer Audio interruption notification: {
    AVAudioSessionInterruptionTypeKey = 1;
}
2017-04-26 23:43:12.105 Doremifasol[5682:5993657] AVSpeechSynthesizer Audio interruption notification: {
    AVAudioSessionInterruptionOptionKey = 1;
    AVAudioSessionInterruptionTypeKey = 0;
}
*/

