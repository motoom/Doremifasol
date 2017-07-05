
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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let defaults = UserDefaults.standard
        rootnote = defaults.object(forKey: "rootnote") as? Int ?? 60
        fixedroot = defaults.object(forKey: "fixedroot") as? Bool ?? false
        register = defaults.object(forKey: "register") as? Int ?? 1
        patch = defaults.object(forKey: "patch") as? Int ?? 0
        ascending = defaults.object(forKey: "ascending") as? Bool ?? true
        descending = defaults.object(forKey: "descending") as? Bool ?? true
        separate = defaults.object(forKey: "separate") as? Bool ?? true
        speaking = defaults.object(forKey: "speaking") as? Bool ?? true
        intervals = defaults.object(forKey: "intervals") as? [Int] ?? [3, 4, 7, 12]
        return true
        }

    func save() {
        let defaults = UserDefaults.standard
        defaults.set(rootnote, forKey: "rootnote")
        defaults.set(fixedroot, forKey: "fixedroot")
        defaults.set(register, forKey: "register")
        defaults.set(patch, forKey: "patch")
        defaults.set(ascending, forKey: "ascending")
        defaults.set(descending, forKey: "descending")
        defaults.set(separate, forKey: "separate")
        defaults.set(speaking, forKey: "speaking")
        defaults.set(intervals, forKey: "intervals")
        }


    func applicationWillResignActive(_ application: UIApplication) {
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

