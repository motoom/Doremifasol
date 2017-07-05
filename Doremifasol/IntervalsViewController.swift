
//  IntervalsViewController.swift

import UIKit

class IntervalsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        for i in 0...17 {
            if let but = view.viewWithTag(i) as? UIButton {
                but.isSelected = intervals.contains(i)
                }
            }
        }

    @IBAction func butClick(_ sender: UIButton) {
        if sender.isSelected {
            if let pos = intervals.index(of: sender.tag) {
                intervals.remove(at: pos)
                }
            }
        else {
            intervals.append(sender.tag)
            }
        sender.isSelected = !sender.isSelected
        }

    }
