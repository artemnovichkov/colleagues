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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .green
        speechService.requestAuthorization()
        speechService.start { results in
            switch results {
            case .success(let result):
                print(result.bestTranscription.formattedString)
            case .error(let error):
                print(error)
            }
        }
    }
}
