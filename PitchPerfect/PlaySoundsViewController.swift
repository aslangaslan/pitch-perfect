//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by Giray Gençaslan on 6.08.2018.
//  Copyright © 2018 Giray Gençaslan. All rights reserved.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {

    // MARK: AVFoundation
    
    var recordedAudioURL: URL!
    var audioFile:AVAudioFile!
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!
    
    // MARK: Outlets
    
    @IBOutlet weak var pauseButton: UIButton!
    @IBOutlet weak var snailButton: UIButton!
    @IBOutlet weak var chipmunkButton: UIButton!
    @IBOutlet weak var rabbitButton: UIButton!
    @IBOutlet weak var vaderButton: UIButton!
    @IBOutlet weak var echoButton: UIButton!
    @IBOutlet weak var reverbButton: UIButton!
    @IBOutlet weak var recordNewAudio: UIButton!
    
    // MARK: Playing state (for changing UI)
    
    enum PlayingState {
        case playing,
        notPlaying
    }
    
    // MARK: Playing types (for triggering play button)
    
    enum PlayingType: Int {
        case slow = 0,
        fast,
        chipmunk,
        vader,
        echo,
        reverb
    }
    
    private var playingState: PlayingState = .notPlaying
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
        navigationItem.title = "Pitch Perfect"
        navigationItem.hidesBackButton = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        // Reset the initial property and UI
        self.playingState = .notPlaying
        configureUI(self.playingState)
    }
    
    @IBAction func recordNewAudio(_ sender: Any) {
        stopAudio()
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func playAudio(_ sender: UIButton) {
        playingState = .playing
        configureUI(self.playingState)
        
        // MARK: Playing types
        
        switch (PlayingType(rawValue: sender.tag)!) {
        case .slow:
            playSound(rate: 0.5)
        case .fast:
            playSound(rate: 1.5)
        case .chipmunk:
            playSound(pitch: 1000)
        case .vader:
            playSound(pitch: -1000)
        case .echo:
            playSound(echo: true)
        case .reverb:
            playSound(reverb: true)
        }
    }
    
    @IBAction func pauseAudio(_ sender: UIButton) {
        playingState = .notPlaying
        configureUI(self.playingState)
        stopAudio()
    }
    
    // MARK: Changing UI
    
    func configureUI(_ playingState: PlayingState) {
        switch playingState {
        case .notPlaying:
            setupButtons(false)
        case .playing:
            setupButtons(true)
        }
    }
    
    func setupButtons(_ enabled: Bool) {
        pauseButton.isEnabled = enabled
        snailButton.isEnabled = !enabled
        chipmunkButton.isEnabled = !enabled
        rabbitButton.isEnabled = !enabled
        vaderButton.isEnabled = !enabled
        echoButton.isEnabled = !enabled
        reverbButton.isEnabled = !enabled
    }
}
