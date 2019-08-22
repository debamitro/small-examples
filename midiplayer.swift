#!/usr/bin/swift

// Command-line MIDI file player
// Just for fun and learning!

import AVFoundation

//
// Maybe this class was unnecessary,
// but I found no other way to ensure that
// the AVMIDIPlayer object is not garbage-collected
//
class MyPlayer
{
    var midiPlayer : AVMIDIPlayer?

    init (filePath: String)
    {
        let fileURL = URL(fileURLWithPath: filePath)
        do
        {
            self.midiPlayer = try AVMIDIPlayer (contentsOf: fileURL, soundBankURL: nil)
            self.midiPlayer!.prepareToPlay()
        }
        catch let error as NSError {
            print ("some error \(error)")
        }

    }

    func play ()
    {
        print ("about to play")
        self.midiPlayer!.play {
            print ("playback complete")
            exit (0)
        }
        if !self.midiPlayer!.isPlaying
        {
            print ("player is not playing yet ...")
        }
    }
}

func doEverything (_ midiFile: String)
{
    let myPlayer = MyPlayer (filePath: midiFile)

    myPlayer.play ()

    RunLoop.main.run()
}

if CommandLine.arguments.count > 1
{
    doEverything (CommandLine.arguments[1])
}
else
{
    print ("usage: midiplayer <MIDI filename>")
}
