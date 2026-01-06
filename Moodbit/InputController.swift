//
//  MoodbitInputController.swift
//  MoodbitInputController
//
//  Created by ensan on 2021/09/07.
//

import Cocoa
import InputMethodKit

var sampleEmojis: [String: String] = [
    ":fire": "🔥",
    ":happy": "😆"
]

enum CollectionState {
    case idle, spaceDetected, live
}

@objc(InputController)
class InputController: IMKInputController {

    private var collectionState: CollectionState = .idle
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
                // Get the actual text that's currently on screen
                let selectedRange = client.selectedRange()
                let actualLength = selectedRange.location - compStartLocation
                
                // Read what's actually on screen to build the buffer from reality
                if let actualText = client.attributedSubstring(from: NSRange(location: compStartLocation, length: actualLength))?.string {
                    buffer = actualText
                }
                
                if sampleEmojis.keys.contains(buffer) {
                    selectedEmoji = sampleEmojis[buffer]!
                } else {
                    selectedEmoji = buffer
                }
                buffer = "" // clear buffer
                client.insertText(selectedEmoji, replacementRange: NSRange(location: compStartLocation, length: actualLength))
                client.insertText(" ", replacementRange: NSRange(location: NSNotFound, length: NSNotFound))
                self.collectionState = .spaceDetected
                return true
            }
            
            // Don't track deletes in buffer - let the screen handle it naturally
            if string == "\u{7F}" { // Delete key
                return false
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
