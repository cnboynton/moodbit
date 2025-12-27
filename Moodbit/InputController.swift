//
//  MoodbitInputController.swift
//  MoodbitInputController
//
//  Created by ensan on 2021/09/07.
//

import Cocoa
import InputMethodKit

var sampleEmojis: [String:String] = [
    ":fire":"🔥",
    ":happy":"😆"
]

enum collectionState {
    case idle, spaceDetected, live
}

@objc(InputController)
class InputController: IMKInputController {

    private var collectionState: collectionState = .idle
    private var buffer: String = ""
    private var selectedEmoji: String = ""
    private var compStartLocation: Int = 0
    private var compLength: Int = 0
    
    override func inputText(_ string: String!, client sender: Any!) -> Bool {
        guard let string = string else { return false }
        // get client to insert
        guard let client = sender as? IMKTextInput else { return false }
        
        // LIVE COLLECTION
        if self.collectionState == .live {
            // IF TERMINATED
            if string == " " {
                if sampleEmojis.keys.contains(buffer) { selectedEmoji = sampleEmojis[buffer]! }
                else { selectedEmoji = buffer }
                compLength = buffer.count
                buffer = "" // clear buffer
                client.insertText(selectedEmoji, replacementRange: NSRange(location: compStartLocation, length: compLength))
                client.insertText(" ", replacementRange: NSRange(location: NSNotFound, length: NSNotFound))
                self.collectionState = .spaceDetected
                return true
            }
            buffer += string
            NSLog(string)
            return false
        }
        // SPACE DETECTED
        else if self.collectionState == .spaceDetected {
            if string == ":" {
                NSLog(string)
                let selectedRange = client.selectedRange()
                compStartLocation = selectedRange.location
                self.collectionState = .live
                buffer += string
            }
            else if string == " " || string == "\n" || client.selectedRange().location == 0 {
                self.collectionState = .spaceDetected
            }
            else {
                self.collectionState = .idle
            }
            return false
        }
        // IDLE
        else {
            if string == " " {
                self.collectionState = .spaceDetected
            }
            return false
        }
    }
}
