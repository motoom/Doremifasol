
//  Speaker.swift



//  ViewController.swift

import UIKit
import AVFoundation

class Speaker: NSObject, AVSpeechSynthesizerDelegate {

    let synth = AVSpeechSynthesizer()
    var ellen: AVSpeechSynthesisVoice? = nil
    var xander: AVSpeechSynthesisVoice? = nil

    override init() {
        super.init()
        synth.delegate = self
        }

    func demo() {
        // Dictation
        // Default taal
        // synthesizer.speakUtterance(AVSpeechUtterance(string: "Hello there, how are you?"))

        // print("Huidige taal:", AVSpeechSynthesisVoice.currentLanguageCode())
        // print("Beschikbare stemmen:", AVSpeechSynthesisVoice.speechVoices())

        loadVoices()
        spreek(ellen, "Hallo daar, hoe gaat het ermee?")
        spreek(xander, "Met mij gaat het goed, dank je wel")
        spreek(ellen, "Tot morgen dan maar weer!")
        }


    func spreek(voice: AVSpeechSynthesisVoice?, _ tekst: String) {
        if let voice = voice {
            let uitspraak = AVSpeechUtterance(string: tekst)
            uitspraak.voice = voice
            synth.speakUtterance(uitspraak)
            }
        }


    func loadVoices() {
        for voice in AVSpeechSynthesisVoice.speechVoices() {
            if voice.name == "Ellen" {
                ellen = voice
                }
            else if voice.name == "Xander" {
                xander = voice
                }
            }
        }


    func speechSynthesizer(synthesizer: AVSpeechSynthesizer, didFinishSpeechUtterance uitspraak: AVSpeechUtterance) {
        print("Klaar met: '\(uitspraak.speechString)'")
        }


    }


/*
Beschikbare stemmen: [[AVSpeechSynthesisVoice 0x17eab540] Language: ar-SA, Name: Maged, Quality: Default, [AVSpeechSynthesisVoice 0x17decd30] Language: cs-CZ, Name: Zuzana, Quality: Default, [AVSpeechSynthesisVoice 0x17debee0] Language: da-DK, Name: Sara, Quality: Default, [AVSpeechSynthesisVoice 0x17de8820] Language: de-DE, Name: Anna, Quality: Default, [AVSpeechSynthesisVoice 0x17eac2a0] Language: el-GR, Name: Melina, Quality: Default, [AVSpeechSynthesisVoice 0x17eaaea0] Language: en-AU, Name: Karen, Quality: Default, [AVSpeechSynthesisVoice 0x17ea9400] Language: en-GB, Name: Daniel, Quality: Default, [AVSpeechSynthesisVoice 0x17eac500] Language: en-IE, Name: Moira, Quality: Default, [AVSpeechSynthesisVoice 0x17debc80] Language: en-US, Name: Samantha (Enhanced), Quality: Enhanced, [AVSpeechSynthesisVoice 0x17debdb0] Language: en-US, Name: Samantha, Quality: Default, [AVSpeechSynthesisVoice 0x17dec270] Language: en-ZA, Name: Tessa, Quality: Default, [AVSpeechSynthesisVoice 0x17deab80] Language: es-ES, Name: Monica, Quality: Default, [AVSpeechSynthesisVoice 0x17debb50] Language: es-MX, Name: Paulina, Quality: Default, [AVSpeechSynthesisVoice 0x17dec010] Language: fi-FI, Name: Satu, Quality: Default, [AVSpeechSynthesisVoice 0x17dea620] Language: fr-CA, Name: Amelie, Quality: Default, [AVSpeechSynthesisVoice 0x17dec3a0] Language: fr-FR, Name: Thomas, Quality: Default, [AVSpeechSynthesisVoice 0x17ea96e0] Language: he-IL, Name: Carmit, Quality: Default, [AVSpeechSynthesisVoice 0x17ea8c70] Language: hi-IN, Name: Lekha, Quality: Default, [AVSpeechSynthesisVoice 0x17eab8e0] Language: hu-HU, Name: Mariska, Quality: Default, [AVSpeechSynthesisVoice 0x17ea9bd0] Language: id-ID, Name: Damayanti, Quality: Default, [AVSpeechSynthesisVoice 0x17dea260] Language: it-IT, Name: Alice, Quality: Default, [AVSpeechSynthesisVoice 0x17eaafc0] Language: ja-JP, Name: Kyoko, Quality: Default, [AVSpeechSynthesisVoice 0x17decad0] Language: ko-KR, Name: Yuna, Quality: Default, [AVSpeechSynthesisVoice 0x17ea9520] Language: nl-BE, Name: Ellen, Quality: Default, [AVSpeechSynthesisVoice 0x17dec610] Language: nl-NL, Name: Xander (Enhanced), Quality: Enhanced, [AVSpeechSynthesisVoice 0x17dec750] Language: nl-NL, Name: Xander, Quality: Default, [AVSpeechSynthesisVoice 0x17deb7b0] Language: no-NO, Name: Nora, Quality: Default, [AVSpeechSynthesisVoice 0x17decc00] Language: pl-PL, Name: Zosia, Quality: Default, [AVSpeechSynthesisVoice 0x17eab400] Language: pt-BR, Name: Luciana, Quality: Default, [AVSpeechSynthesisVoice 0x17eaac50] Language: pt-PT, Name: Joana, Quality: Default, [AVSpeechSynthesisVoice 0x17eaa990] Language: ro-RO, Name: Ioana, Quality: Default, [AVSpeechSynthesisVoice 0x17eac3d0] Language: ru-RU, Name: Milena, Quality: Default, [AVSpeechSynthesisVoice 0x17eab0f0] Language: sk-SK, Name: Laura, Quality: Default, [AVSpeechSynthesisVoice 0x17d78790] Language: sv-SE, Name: Alva, Quality: Default, [AVSpeechSynthesisVoice 0x17eaad70] Language: th-TH, Name: Kanya, Quality: Default, [AVSpeechSynthesisVoice 0x17dec870] Language: tr-TR, Name: Yelda, Quality: Default, [AVSpeechSynthesisVoice 0x17dec4d0] Language: zh-CN, Name: Ting-Ting, Quality: Default, [AVSpeechSynthesisVoice 0x17dec140] Language: zh-HK, Name: Sin-Ji, Quality: Default, [AVSpeechSynthesisVoice 0x17eac160] Language: zh-TW, Name: Mei-Jia, Quality: Default]
*/



