
//  MidiSampler.swift - version 22 apr 2017
//
// Derived from https://raw.githubusercontent.com/genedelisa/MusicSequenceAUGraph
//
// To use instruments instead of sine waves: Add GeneralMidi.sf2 to the project
//
// MIDI spec: https://www.midi.org/specifications/item/table-1-summary-of-midi-message

import Foundation
import AudioToolbox

class MidiSampler  {

    var graph: AUGraph
    var sampler: AudioUnit


    init(_ patch: Int = 0, percussive: Bool = false) {
        self.graph = nil
        self.sampler = nil
        graphSetup()
        graphStart()
        programChange(patch, percussive)
        }


    deinit {
        AUGraphStop(self.graph)
        }


    func graphSetup() {
        NewAUGraph(&self.graph)

        var samplerNode = AUNode()
        var scd = AudioComponentDescription(
            componentType: OSType(kAudioUnitType_MusicDevice),
            componentSubType: OSType(kAudioUnitSubType_Sampler),
            componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
            componentFlags: 0,
            componentFlagsMask: 0)
        AUGraphAddNode(self.graph, &scd, &samplerNode)

        var ioNode = AUNode()
        var ioUnitDescription = AudioComponentDescription(
            componentType: OSType(kAudioUnitType_Output),
            componentSubType: OSType(kAudioUnitSubType_RemoteIO),
            componentManufacturer: OSType(kAudioUnitManufacturer_Apple),
            componentFlags: 0,
            componentFlagsMask: 0)
        AUGraphAddNode(self.graph, &ioUnitDescription, &ioNode)

        AUGraphOpen(self.graph)

        AUGraphNodeInfo(self.graph, samplerNode, nil, &self.sampler)

        var ioUnit: AudioUnit = nil
        AUGraphNodeInfo(self.graph, ioNode, nil, &ioUnit)

        let ioUnitOutputElement = AudioUnitElement(0)
        let samplerOutputElement = AudioUnitElement(0)

        AUGraphConnectNodeInput(self.graph, samplerNode, samplerOutputElement, ioNode, ioUnitOutputElement)
        }
    

    func graphRunning() -> Bool {
        var isRunning = DarwinBoolean(false)
        AUGraphIsRunning(self.graph, &isRunning)
        return Bool(isRunning)
        }


    func graphStart() {
        var outIsInitialized: DarwinBoolean = false
        AUGraphIsInitialized(self.graph, &outIsInitialized)
        if outIsInitialized == false {
            AUGraphInitialize(self.graph)
            }
        if graphRunning() == false {
            AUGraphStart(self.graph)
            }
        }


    func noteOn(noteNum: Int, _ velocity: Int = 120)    {
        MusicDeviceMIDIEvent(self.sampler, 0x90, UInt32(noteNum), UInt32(velocity), 0)
        }


    func noteOff(noteNum: Int) {
        MusicDeviceMIDIEvent(self.sampler, 0x80, UInt32(noteNum), 0, 0)
        }


    func allOff() { // all notes off + reset all controllers
        MusicDeviceMIDIEvent(self.sampler, 0xB0, 0x7B, 0, 0)
        MusicDeviceMIDIEvent(self.sampler, 0xB0, 0x79, 0, 0)
        }


    func pan(position: Int) { // Pan -64..64
        let c = UInt32(position + 64)
        MusicDeviceMIDIEvent(self.sampler, 0xB0, 10, c, 0)
        }


    func programChange(patch: Int = 0, _ percussive: Bool = false)  {
        guard let bankURL = NSBundle.mainBundle().URLForResource("gm", withExtension: "sf2") else {
            fatalError("\"gm.sf2\" file not found.")
            }
        var instdata = AUSamplerInstrumentData(fileURL: Unmanaged.passUnretained(bankURL),
                                               instrumentType: UInt8(kInstrumentType_SF2Preset),
                                               bankMSB: percussive ? UInt8(kAUSampler_DefaultPercussionBankMSB) : UInt8(kAUSampler_DefaultMelodicBankMSB),
                                               bankLSB: UInt8(kAUSampler_DefaultBankLSB),
                                               presetID: UInt8(patch))
        AudioUnitSetProperty(
            self.sampler,
            AudioUnitPropertyID(kAUSamplerProperty_LoadInstrument),
            AudioUnitScope(kAudioUnitScope_Global),
            0, &instdata, UInt32(sizeof(AUSamplerInstrumentData)))
        }


    static let notenamesFlat: [String] = ["C", "D♭", "D", "E♭", "E", "F", "G♭", "G", "A♭", "A", "B♭", "B", "C"]
    static let notenamesSharp: [String] = ["C", "C♯", "D", "D♯", "E", "F", "F♯", "G", "G♯", "A", "A♯", "B", "C"]


    static func prtmidinote(note: Int, preferFlat: Bool = true, withOctave: Bool = true) -> String {
        var s = ""
        if preferFlat {
            s = self.notenamesFlat[note % 12]
            }
        else {
            s = self.notenamesSharp[note % 12]
            }
        if withOctave {
            let octave = Int(note / 12)
            s += String(octave)
            }
        return s
        }


    // Alternative general MIDI instrument names at Wikipedia, https://en.wikipedia.org/wiki/MIDI
    static let patchnames = [
        // 0..7
        "Piano 1",
        "Piano 2",
        "Piano 3",
        "Honky-tonk Piano",
        "E.Piano 1",
        "E.Piano 2",
        "Harpsichord",
        "Clavinet",

        // 8..15
        "Celesta",
        "Glockenspiel",
        "Music Box",
        "Vibraphone",
        "Marimba",
        "Xylophone",
        "Tubular-bell",
        "Santur",

        // 16..23
        "Organ 1",
        "Organ 2",
        "Organ 3",
        "Church Organ",
        "Reed Organ",
        "Accordion",
        "Harmonica",
        "Bandoneon",

        // 24..31
        "Nylon-string Guitar",
        "Steel-string Guitar",
        "Jazz Guitar",
        "Clean Guitar",
        "Muted Guitar",
        "Overdrive Guitar",
        "Distortion Guitar",
        "Guitar Harmonics",

        // 32..39
        "Acoustic Bass",
        "Fingered Bass",
        "Picked Bass",
        "Fretless Bass",
        "Slap Bass 1",
        "Slap Bass 2",
        "Synth Bass 1",
        "Synth Bass 2",

        // 40..47
        "Violin",
        "Viola",
        "Cello",
        "Contrabass",
        "Tremolo Strings",
        "Pizzicato Strings",
        "Harp",
        "Timpani",

        // 48..55
        "Strings",
        "Slow Strings",
        "Syn. Strings 1",
        "Syn. Strings 2",
        "Choir Aahs",
        "Voice Oohs",
        "SynVox",
        "Orchestra Hit",

        // 56..63
        "Trumpet",
        "Trombone",
        "Tuba",
        "Muted Trumpet",
        "French Horn",
        "Brass",
        "Synth Brass 1",
        "Synth Brass 2",

        // 64..71
        "Soprano Sax",
        "Alto Sax",
        "Tenor Sax",
        "Baritone Sax",
        "Oboe",
        "English Horn",
        "Bassoon",
        "Clarinet",

        // 72..80
        "Piccolo",
        "Flute",
        "Recorder",
        "Pan Flute",
        "Bottle Blow",
        "Shakuhachi",
        "Whistle",
        "Ocarina",

        "Square Wave",
        "Saw Wave",
        "Syn. Calliope",
        "Chiffer Lead",
        "Charang",
        "Solo Vox",
        "5th Saw Wave",
        "Bass & Lead",

        "Fantasia",
        "Warm Pad",
        "Polysynth",
        "Space Voice",
        "Bowed Glass",
        "Metal Pad",
        "Halo Pad",
        "Sweep Pad",

        "Ice Rain",
        "Soundtrack",
        "Crystal",
        "Atmosphere",
        "Brightness",
        "Goblin",
        "Echo Drops",
        "Star Theme",

        "Sitar",
        "Banjo",
        "Shamisen",
        "Koto",
        "Kalimba",
        "Bagpipe",
        "Fiddle",
        "Shanai",

        "Tinkle Bell",
        "Agogo",
        "Steel Drums",
        "Woodblock",
        "Taiko",
        "Melo. Tom 1",
        "Synth Drum",
        "Reverse Cymbal",

        "Guitar Fret Noise",
        "Breath Noise",
        "Seashore",
        "Bird",
        "Telephone",
        "Helicopter",
        "Applause",
        "Gun Shot",
        ]
        
    }






