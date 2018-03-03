//
//  ViewController.swift
//  UDL
//
//  Created by s on 2018-03-02.
//  Copyright © 2018 Carspotter Daily. All rights reserved.
//

import Cocoa
import FlatButton

class MainView: NSViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.view.wantsLayer = true
        self.view.layer?.backgroundColor = NSColor.darkGray.cgColor
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    var output = String()
    @discardableResult
    func shell(_ args: String...) -> (String?, Int32) {
        let task = Process()
        task.launchPath = Bundle.main.path(forResource: "youtube-dl", ofType: nil)
        task.arguments = args
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.launch()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        output = String(data: data, encoding: .utf8)!
        print("OUTPUT::  ", output)
        task.waitUntilExit()
        return (output, task.terminationStatus)
    }

    @IBOutlet weak var YRL: NSTextField!
    @IBOutlet weak var UDL: NSTextField!
    @IBOutlet weak var Qual: NSPopUpButton!
    @IBOutlet weak var Frmt: NSPopUpButton!
    @IBOutlet weak var Location: NSPathControl!
    @IBOutlet weak var Convert: FlatButton!
    @IBOutlet weak var isPlaylist: NSButton!
    
    @IBAction func Convert(_ sender: Any) {
        if(Frmt.title)
        if(YRL.stringValue != "") {
            if(self.isPlaylist.state != NSControlStateValueOn) {
            shell("-x", "--audio-format", Frmt.selectedItem!.title, "--audio-quality", "\(self.Qual.integerValue - 1)",  "--ffmpeg-location", Bundle.main.path(forResource: "ffmpeg", ofType: nil)!, "-o", (self.Location.url!.path + "/%(title)s.%(ext)s"), self.YRL.stringValue)
                print("-x", "--audio-format", Frmt.selectedItem!.title, "--audio-quality", "\(self.Qual.integerValue)",  "--ffmpeg-location", Bundle.main.path(forResource: "ffmpeg", ofType: nil)!, "-o", (self.Location.url!.path + "/%(title)s.%(ext)s"), self.YRL.stringValue)
            } else {
                shell("-x", "--audio-format", Frmt.selectedItem!.title, "--audio-quality", "\(self.Qual.integerValue)", "-o", (self.Location.url!.path + "/%(title)s.%(ext)s"), "--yes-playlist", "--ffmpeg-location", Bundle.main.path(forResource: "ffmpeg", ofType: nil)!, self.YRL.stringValue)
            }
        }
    }
    
}

