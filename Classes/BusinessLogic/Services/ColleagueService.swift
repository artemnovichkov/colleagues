//
//  ColleagueService.swift
//  Colleagues
//
//  Created by Artem Novichkov on 05/06/2017.
//  Copyright © 2017 artemnovichkov. All rights reserved.
//

import UIKit
import Speech

final class ColleagueService {
    
    func colleagueImage(forTranscription transcription: SFTranscription) -> UIImage? {
        for segment in transcription.segments {
            if NamesFactory.nikitaNames.contains(segment.substring) {
                return #imageLiteral(resourceName: "nikita")
            }
            if NamesFactory.dimaNames.contains(segment.substring) {
                return #imageLiteral(resourceName: "dima")
            }
            if NamesFactory.jekaNames.contains(segment.substring) {
                return #imageLiteral(resourceName: "jeka")
            }
            if NamesFactory.antonNames.contains(segment.substring) {
                return #imageLiteral(resourceName: "anton")
            }
        }
        return nil
    }
}

final class NamesFactory {
    
    static let nikitaNames = ["Никита", "Никитос", "Никиту", "Никитку", "Никитоса", "Наруто"]
    static let dimaNames = ["Дима", "Диму", "Димку", "Димона", "Дмитрия"]
    static let jekaNames = ["Жеку", "Жека", "Евгений", "Евгения"]
    static let antonNames = ["Антон", "Антона", "Антошку", "Антоху"]
}
