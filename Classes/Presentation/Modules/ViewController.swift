//
//  ViewController.swift
//  Colleagues
//
//  Created by Artem Novichkov on 05/06/2017.
//  Copyright © 2017 artemnovichkov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    let speechService = SpeechService(locale: Locale(identifier: "ru-RU"))!
    let colleagueService = ColleagueService()
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var recordButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        speechService.requestAuthorization()
    }
    
    // MARK: - Actions
    
    @IBAction func recordButtonAction(_ sender: Any) {
        recordButton.isSelected = !recordButton.isSelected
        if recordButton.isSelected {
            startRecording()
        }
        else {
            stopRecording()
        }
    }
    
    func startRecording() {
        speechService.start { [weak self] results in
            switch results {
            case .success(let result):
                self?.imageView.image = self?.colleagueService.colleagueImage(forTranscription: result.bestTranscription)
                print(result.bestTranscription.formattedString)
            case .error(let error):
                print(error)
            }
        }
    }
    
    func stopRecording() {
        speechService.stop()
    }
}
