//
//  SpeechService.swift
//  Colleagues
//
//  Created by Artem Novichkov on 05/06/2017.
//  Copyright © 2017 artemnovichkov. All rights reserved.
//

import Speech

final class SpeechService: NSObject {
    
    private let recognizer: SFSpeechRecognizer
    private let audioEngine = AVAudioEngine()
    private var request: SFSpeechAudioBufferRecognitionRequest?
    
    init?(locale: Locale) {
        if let recognizer = SFSpeechRecognizer(locale: locale) {
            self.recognizer = recognizer
            super.init()
            self.recognizer.delegate = self
        }
        else {
            return nil
        }
    }
    
    func requestAuthorization() {
        SFSpeechRecognizer.requestAuthorization { status in
            switch status {
            case .authorized:
                print("done!")
            case .denied, .notDetermined, .restricted:
                print("false...")
            }
        }
    }
    
    enum Results {
        case success(SFSpeechRecognitionResult), error(Error)
    }
    
    func start(resultHandler: @escaping (Results) -> Void) {
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(AVAudioSessionCategoryRecord)
            try session.setMode(AVAudioSessionModeMeasurement)
            try session.setActive(true, with: .notifyOthersOnDeactivation)
        }
        catch {
            resultHandler(.error(error))
        }
        
        let request = SFSpeechAudioBufferRecognitionRequest()
        recognizer.recognitionTask(with: request) { result, error in
            if let result = result, result.isFinal {
                resultHandler(.success(result))
            }
            if let error = error {
                resultHandler(.error(error))
            }
        }
        self.request = request
        
        guard let inputNode = audioEngine.inputNode else { fatalError("Empty Input node") }
        let recordFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordFormat) { buffer, _ in
            request.append(buffer)
        }
        
        do {
            audioEngine.prepare()
            try audioEngine.start()
        }
        catch {
            resultHandler(.error(error))
        }
    }
    
    func stop() {
        request?.endAudio()
        audioEngine.stop()
        audioEngine.inputNode?.removeTap(onBus: 0)
    }
}

extension SpeechService: SFSpeechRecognizerDelegate {
    
    func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        print("availabilityDidChange: \(available)")
    }
}
