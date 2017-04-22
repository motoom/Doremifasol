
//  MidiSampler.swift - version 22 apr 2017
//
// Derived from https://raw.githubusercontent.com/genedelisa/MusicSequenceAUGraph
//
// To use instruments instead of sine waves: Add GeneralMidi.sf2 to the project
//
// MIDI spec: https://www.midi.org/specifications/item/table-1-summary-of-midi-message

// 'Opus Superbus'

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
    
    
    func graphStart() {
        var outIsInitialized: DarwinBoolean = false
        AUGraphIsInitialized(self.graph, &outIsInitialized)
        if outIsInitialized == false {
            AUGraphInitialize(self.graph)
            }
        var isRunning = DarwinBoolean(false)
        AUGraphIsRunning(self.graph, &isRunning)
        if isRunning == false {
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





/*
General MIDI (from Wikipedia) https://en.wikipedia.org/wiki/MIDI

This list starts with 1, but the patch numbers run from 0 to 127.

    1 Acoustic Grand Piano
    2 Bright Acoustic Piano
    3 Electric Grand Piano
    4 Honky-tonk Piano
    5 Electric Piano 1
    6 Electric Piano 2
    7 Harpsichord
    8 Clavinet

Chromatic Percussion

    9 Celesta
    10 Glockenspiel
    11 Music Box
    12 Vibraphone
    13 Marimba
    14 Xylophone
    15 Tubular Bells
    16 Dulcimer

Organ

    17 Drawbar Organ
    18 Percussive Organ
    19 Rock Organ
    20 Church Organ
    21 Reed Organ
    22 Accordion
    23 Harmonica
    24 Tango Accordion

Guitar

    25 Acoustic Guitar (nylon)
    26 Acoustic Guitar (steel)
    27 Electric Guitar (jazz)
    28 Electric Guitar (clean)
    29 Electric Guitar (muted)
    30 Overdriven Guitar
    31 Distortion Guitar
    32 Guitar Harmonics

Bass

    33 Acoustic Bass
    34 Electric Bass (finger)
    35 Electric Bass (pick)
    36 Fretless Bass
    37 Slap Bass 1
    38 Slap Bass 2
    39 Synth Bass 1
    40 Synth Bass 2

Strings

    41 Violin
    42 Viola
    43 Cello
    44 Contrabass
    45 Tremolo Strings
    46 Pizzicato Strings
    47 Orchestral Harp
    48 Timpani

Ensemble

    49 String Ensemble 1
    50 String Ensemble 2
    51 Synth Strings 1
    52 Synth Strings 2
    53 Choir Aahs
    54 Voice Oohs
    55 Synth Choir
    56 Orchestra Hit

Brass

    57 Trumpet
    58 Trombone
    59 Tuba
    60 Muted Trumpet
    61 French Horn
    62 Brass Section
    63 Synth Brass 1
    64 Synth Brass 2

Reed

    65 Soprano Sax
    66 Alto Sax
    67 Tenor Sax
    68 Baritone Sax
    69 Oboe
    70 English Horn
    71 Bassoon
    72 Clarinet

Pipe

    73 Piccolo
    74 Flute
    75 Recorder
    76 Pan Flute
    77 Blown bottle
    78 Shakuhachi
    79 Whistle
    80 Ocarina

Synth Lead

    81 Lead 1 (square)
    82 Lead 2 (sawtooth)
    83 Lead 3 (calliope)
    84 Lead 4 (chiff)
    85 Lead 5 (charang)
    86 Lead 6 (voice)
    87 Lead 7 (fifths)
    88 Lead 8 (bass + lead)

Synth Pad

    89 Pad 1 (new age)
    90 Pad 2 (warm[disambiguation needed])
    91 Pad 3 (polysynth)
    92 Pad 4 (choir)
    93 Pad 5 (bowed)
    94 Pad 6 (metallic)
    95 Pad 7 (halo)
    96 Pad 8 (sweep)

Synth Effects

    97 FX 1 (rain)
    98 FX 2 (soundtrack)
    99 FX 3 (crystal)
    100 FX 4 (atmosphere)
    101 FX 5 (brightness)
    102 FX 6 (goblins)
    103 FX 7 (echoes)
    104 FX 8 (sci-fi)

Ethnic

    105 Sitar
    106 Banjo
    107 Shamisen
    108 Koto
    109 Kalimba
    110 Bagpipe
    111 Fiddle
    112 Shanai

Percussive

    113 Tinkle Bell
    114 Agogo
    115 Steel Drums
    116 Woodblock
    117 Taiko Drum
    118 Melodic Tom
    119 Synth Drum
    120 Reverse Cymbal

Sound effects

    121 Guitar Fret Noise
    122 Breath Noise
    123 Seashore
    124 Bird Tweet
    125 Telephone Ring
    126 Helicopter
    127 Applause
    128 Gunshot


GM Standard Drum Map

    35 Bass Drum 2
    36 Bass Drum 1
    37 Side Stick/Rimshot
    38 Snare Drum 1
    39 Hand Clap
    40 Snare Drum 2
    41 Low Tom 2
    42 Closed Hi-hat
    43 Low Tom 1
    44 Pedal Hi-hat
    45 Mid Tom 2
    46 Open Hi-hat
    47 Mid Tom 1
    48 High Tom 2
    49 Crash Cymbal 1
    50 High Tom 1
    51 Ride Cymbal 1
    52 Chinese Cymbal
    53 Ride Bell
    54 Tambourine
    55 Splash Cymbal
    56 Cowbell
    57 Crash Cymbal 2
    58 Vibra Slap
    59 Ride Cymbal 2
    60 High Bongo
    61 Low Bongo
    62 Mute High Conga
    63 Open High Conga
    64 Low Conga
    65 High Timbale
    66 Low Timbale
    67 High Agogô
    68 Low Agogô
    69 Cabasa
    70 Maracas
    71 Short Whistle
    72 Long Whistle
    73 Short Güiro
    74 Long Güiro
    75 Claves
    76 High Wood Block
    77 Low Wood Block
    78 Mute Cuíca
    79 Open Cuíca
    80 Mute Triangle
    81 Open Triangle
*/

