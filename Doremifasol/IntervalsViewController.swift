
//  IntervalsViewController.swift

import UIKit

class IntervalsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...17 {
            if let but = view.viewWithTag(i) as? UIButton {
                but.selected = intervals.contains(i)
                }
            }
        }

    @IBAction func butClick(sender: UIButton) {
        if sender.selected {
            if let pos = intervals.indexOf(sender.tag) {
                intervals.removeAtIndex(pos)
                }
            }
        else {
            intervals.append(sender.tag)
            }
        sender.selected = !sender.selected
        }

    }
