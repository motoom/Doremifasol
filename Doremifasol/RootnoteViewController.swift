
//  RootnoteViewController.swift

import UIKit

class RootnoteViewController: UIViewController {

    @IBOutlet weak var instrumentSegment: UISegmentedControl!
    @IBOutlet weak var registerSegment: UISegmentedControl!
    @IBOutlet weak var directionSegment: UISegmentedControl!
    @IBOutlet weak var separatedSwitch: UISwitch!
    @IBOutlet weak var speakSwitch: UISwitch!
    @IBOutlet weak var fixedrootSwitch: UISwitch!

    override func viewDidLoad() {
        switch(patch) {
            case 0: instrumentSegment.selectedSegmentIndex = 0 // piano
            case 73: instrumentSegment.selectedSegmentIndex = 1 // flute
            case 53: instrumentSegment.selectedSegmentIndex = 2 // oooh
            case 32: instrumentSegment.selectedSegmentIndex = 3 // acoustic bass
            default: break
            }

        registerSegment.selectedSegmentIndex = register

        if descending && ascending {
            directionSegment.selectedSegmentIndex = 1
            }
        else if descending {
            directionSegment.selectedSegmentIndex = 0
            }
        else {
            directionSegment.selectedSegmentIndex = 2
            }

        separatedSwitch.setOn(separate, animated: false)
        speakSwitch.setOn(speaking, animated: false)
        fixedrootSwitch.setOn(fixedroot, animated: false)
        }


    @IBAction func patchChanged(sender: UISegmentedControl) {
        let patches = [0, 73, 53, 32]
        patch = patches[sender.selectedSegmentIndex]
        sampler?.programChange(patch)
        }


    @IBAction func registerChanged(sender: UISegmentedControl) {
        register = sender.selectedSegmentIndex
        }


    @IBAction func directionChanged(sender: UISegmentedControl) {
        switch(sender.selectedSegmentIndex) {
            case 0: descending = true; ascending = false
            case 1: descending = true; ascending = true
            case 2: descending = false; ascending = true
            default: break
            }
        }


    @IBAction func separateChanged(sender: UISwitch) {
        separate = sender.on
        }


    @IBAction func speakingChanged(sender: UISwitch) {
        speaking = sender.on
        }

    @IBAction func fixedrootChange(sender: UISwitch) {
        fixedroot = sender.on
        }


    }
