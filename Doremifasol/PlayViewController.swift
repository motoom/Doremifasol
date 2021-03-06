//  PlayViewController.swift // TODO: Pause/Start button

// IDEE: Noten ook op een notebalk laten zien. Sleutel (G/F) kiesbaar.
// programma icon
// engels vertalen
// icoontjes voor de tabcontroller
// foto's achter de views
// hoe iets op de appstore

import UIKit
import AVFoundation

class PlayViewController: UIViewController {

    var timer: Timer?
    var paused = false
    var speaker: AVSpeechSynthesizer?
    var dutchVoice: AVSpeechSynthesisVoice? = nil
    var englishVoice: AVSpeechSynthesisVoice? = nil

    var firstnote = 0
    var secondnote = 0
    var steps = 0
    var preferflat = true

    // TODO: FLuit blaast 5 seconden door.
    var solutionDelay = 5.0

    @IBOutlet weak var firstNoteLabel: UILabel!
    @IBOutlet weak var secondNoteLabel: UILabel!
    @IBOutlet weak var intervalNameLabel: UILabel!
    @IBOutlet weak var pauseButton: UIButton!



    let intervalNameDutch: [String] = ["priem","kleine secunde","secunde","kleine terts",
					"grote terts","kwart","verminderde kwint","kwint","overmatige kwint",
					"sext","klein septiem","groot septiem","octaaf","kleine none", "none",
                    "kleine decime", "grote decime", "undecime"]

    let intervalNameEnglish: [String] = ["prime","minor second","second","minor third",
					 "third","fourth","augmented fourth","fifth","augmented fifth",
					 "sixth","minor seventh","major seventh","octave",
                    "minor ninth", "ninth", "minor tenth", "major tenth", "eleventh"]

    var intervalName = [String]()


    func randyesno() -> Bool {
        return arc4random_uniform(2) == 1
        }


    func randbetween(_ lo: Float, _ hi: Float) -> Float {
        let range = hi - lo
        let v = Float(arc4random_uniform(UInt32.max)) / Float(UInt32.max) // 0...1
        return lo + v * range
        }


    func cleartimer() {
        if let tim = timer {
            tim.invalidate()
            timer = nil
            }
        }


    override func viewDidLoad() {
        super.viewDidLoad()

        // So that the AppDelegate can pause us when a phone call occurs, or the user switches to another app.
        let ad = UIApplication.shared.delegate as! AppDelegate
        ad.playViewController = self

        sampler = MidiSampler(patch)

        speaker = AVSpeechSynthesizer()
        speaker?.delegate = self
        let currentLanguage = AVSpeechSynthesisVoice.currentLanguageCode()
        // If the language is Dutch, prefer Ellen as voice.
        if currentLanguage.hasPrefix("nl-") {
            for voice in AVSpeechSynthesisVoice.speechVoices() {
                if voice.name == "Ellen" {
                    dutchVoice = voice
                    break
                    }
                }
            intervalName = intervalNameDutch // ...and use the Dutch interval names.
            }
        // If the language is not Dutch, use English voice and interval names
        else {
            for voice in AVSpeechSynthesisVoice.speechVoices() {
                if voice.name == "Samantha" {
                    englishVoice = voice
                    break
                    }
                }
            intervalName = intervalNameEnglish
            }

        firstNoteLabel.text = ""
        secondNoteLabel.text = ""
        intervalNameLabel.text = ""
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PlayViewController.chooseNotes), userInfo: nil, repeats: false)
        }


    // Initiate a pause.
    func pause() {
        if paused {
            return
            }
        cleartimer()
        sampler?.allOff()
        sampler = nil
        paused = true
        pauseButton.setImage(UIImage(named: "button-play"), for: UIControlState())
        firstNoteLabel.text = ""
        secondNoteLabel.text = ""
        intervalNameLabel.text = "paused"
        view.setNeedsDisplay()
        }


    // End the pause; go back to playing state.
    func unpause() {
        if !paused {
            return
            }
        cleartimer()
        sampler = MidiSampler(patch)
        sampler?.allOff()
        paused = false
        pauseButton.setImage(UIImage(named: "button-pause"), for: UIControlState())
        firstNoteLabel.text = ""
        secondNoteLabel.text = ""
        intervalNameLabel.text = "starting..."
        view.setNeedsDisplay()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PlayViewController.chooseNotes), userInfo: nil, repeats: false)
        }


    @IBAction func pauseClicked(_ sender: UIButton) {
        if paused {
            unpause()
            }
        else {
            pause()
            }
        }


    func chooseNotes() {
        cleartimer()
        firstNoteLabel.text = ""
        secondNoteLabel.text = ""
        intervalNameLabel.text = ""

        // Choose first note (near the root)
        firstnote = rootnote
        if !fixedroot {
            firstnote += Int(arc4random_uniform(12)) - 6
            }

        // Adjust for lower or higher register (bass, treble option)
        if register == 0 {
            firstnote -= 2*12
            }
        if register == 2 {
            firstnote += 1*12
            }

        // Second note
        if intervals.count > 0 {
            steps = intervals[Int(arc4random()) % intervals.count]
            }

        if descending && ascending { // Second note could be lower or higher than first note
            if randyesno() {
                secondnote = firstnote - steps
                }
            else {
                secondnote = firstnote + steps
                }
            }
        else if descending { // Second note should always be lower than first note
            secondnote = firstnote - steps
            }
        else { // Second note should always be higher than first note
            secondnote = firstnote + steps
            }

        // Slide both, so that both notes are higher than midi note 28 (==E2, 40Hz, lowest string on 4-stringed bass guitar). Low B string would be 23 (30Hz).
        while firstnote < 28 || secondnote < 28 {
            firstnote += 1
            secondnote += 1
            }

        // Whether we use flats or sharps for these two notes
        preferflat = randyesno()

        if separate {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PlayViewController.playFirstNote), userInfo: nil, repeats: false)
            }
        else {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PlayViewController.playBothNotes), userInfo: nil, repeats: false)
            }
        }


    func playFirstNote() {
        cleartimer()

        sampler?.noteOn(firstnote)
        if secondnote >= firstnote {
            firstNoteLabel.text = MidiSampler.prtmidinote(firstnote, preferFlat: preferflat, withOctave: false)
            }
        else {
            secondNoteLabel.text = MidiSampler.prtmidinote(firstnote, preferFlat: preferflat, withOctave: false)
            }

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PlayViewController.playSecondNote), userInfo: nil, repeats: false)
        }


    func playSecondNote() {
        cleartimer()
        sampler?.noteOff(firstnote)
        sampler?.noteOn(secondnote)
        if secondnote >= firstnote {
            secondNoteLabel.text = MidiSampler.prtmidinote(secondnote, preferFlat: preferflat, withOctave: false)
            }
        else {
            firstNoteLabel.text = MidiSampler.prtmidinote(secondnote, preferFlat: preferflat, withOctave: false)
            }
        timer = Timer.scheduledTimer(timeInterval: solutionDelay, target: self, selector: #selector(PlayViewController.showSolution), userInfo: nil, repeats: false)
        }


    func playBothNotes() {
        cleartimer()
        sampler?.noteOn(firstnote)
        sampler?.noteOn(secondnote)
        if secondnote >= firstnote {
            firstNoteLabel.text = MidiSampler.prtmidinote(firstnote, preferFlat: preferflat, withOctave: false)
            secondNoteLabel.text = MidiSampler.prtmidinote(secondnote, preferFlat: preferflat, withOctave: false)
            }
        else {
            firstNoteLabel.text = MidiSampler.prtmidinote(secondnote, preferFlat: preferflat, withOctave: false)
            secondNoteLabel.text = MidiSampler.prtmidinote(firstnote, preferFlat: preferflat, withOctave: false)
            }
        timer = Timer.scheduledTimer(timeInterval: solutionDelay, target: self, selector: #selector(PlayViewController.showSolution), userInfo: nil, repeats: false)
        }


    func showSolution() {
        cleartimer()
        sampler?.noteOff(firstnote)
        sampler?.noteOff(secondnote)
        intervalNameLabel.text = intervalName[steps]
        if speaking {
            if let voice = dutchVoice {
                let utterance = AVSpeechUtterance(string: intervalName[steps])
                utterance.voice = voice
                utterance.pitchMultiplier = randbetween(0.8, 1.2)
                utterance.rate = randbetween(0.45, 0.55)
                speaker?.speak(utterance)
                }
            else if let voice = englishVoice {
                let utterance = AVSpeechUtterance(string: intervalName[steps])
                utterance.voice = voice
                utterance.pitchMultiplier = randbetween(0.8, 1.2)
                utterance.rate = randbetween(0.45, 0.55)
                speaker?.speak(utterance)
                }
            else {
                // No usable voice.
                timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(PlayViewController.chooseNotes), userInfo: nil, repeats: false)
                }
            }
        else {
            timer = Timer.scheduledTimer(timeInterval: 2.0, target: self, selector: #selector(PlayViewController.chooseNotes), userInfo: nil, repeats: false)
            }
        }
    }


extension PlayViewController: AVSpeechSynthesizerDelegate {
    // Called when the speech synthesizer is done speaking.
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        if !paused {
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(PlayViewController.chooseNotes), userInfo: nil, repeats: false)
            }
        }
    }
