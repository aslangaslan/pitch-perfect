//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by Giray Gençaslan on 6.08.2018.
//  Copyright © 2018 Giray Gençaslan. All rights reserved.
//
import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {

    enum RecordingState { case recording, notRecording }
    
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var recordButton: UIButton!
    
    var audioRecorder: AVAudioRecorder!
    var isRecording: Bool = false
    
    // MARK: View loading / appearing
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.title = "Pitch Perfect"
        
        // Navigation bar shadow dismissed
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navigationController?.navigationBar.shadowImage = UIImage()
    
        // Change navigation bar tint color and title color
        navigationController?.navigationBar.barTintColor = UIColor(red:0.24, green:0.31, blue:0.36, alpha:1.0)
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.isRecording = false
        
        // Check permission each appear (if user not appear first time, he can change permission in settings)
        AVAudioSession.sharedInstance().requestRecordPermission { (allowed) in
            if allowed {
                DispatchQueue.main.async { self.recordButton.isEnabled = true }
            } else {
                DispatchQueue.main.async { self.recordButton.isEnabled = false }
                let alert = UIAlertController(title: "Warning", message: "You can not use application without giving permission", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        }

    }
    
    // MARK: Audio functions

    @IBAction func recordStopAudio(_ sender: Any) {
        configureUI(isRecording: self.isRecording)
        
        // Recording start / stop function. Functioning changes based on isRecording property.
        // If isRecording is true, we will stop the recording
        // Else we initialize and start recording
        if isRecording {
            isRecording = false
            audioRecorder.stop()
            let audioSession = AVAudioSession.sharedInstance()
            try! audioSession.setActive(false)
        } else {
            isRecording = true
            let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
            let recordingName = "recordedVoice.wav"
            let pathArray = [dirPath, recordingName]
            let filePath = URL(string: pathArray.joined(separator: "/"))
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSessionCategoryPlayAndRecord, with:AVAudioSessionCategoryOptions.defaultToSpeaker)
            
            try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
        } else {
            print("Recording was not succesfull")
        }
    }
    
    // MARK: Changing UI
    
    func configureUI(isRecording: Bool) {
        if isRecording {
            recordButton.setImage(UIImage(named: "Record.png"), for: .normal)
        } else {
            recordButton.setImage(UIImage(named: "Stop.png"), for: .normal)
        }
    }
    
    // MARK: Segues
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            guard let destinationVC = segue.destination as? PlaySoundsViewController else { return }
            guard let recordedAudioURL = sender as? URL else { return }
            destinationVC.recordedAudioURL = recordedAudioURL
        }
    }
}
