//
//  SpeachRecognizer.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 08/10/21.
//

import UIKit
import AVFoundation
final class SpeachRecognizerData:NSObject {
    let synth = AVSpeechSynthesizer()
    let userDefault = UserDefaults.standard
    static var objShared = SpeachRecognizerData()
    var strLanguage:String = "en-US"
    private override init() {
    }
    func setupValueForSpeak(strValue:String) {
        let speakValue =  userDefault.bool(forKey: kSpeach)
        if speakValue {
            let utterance = AVSpeechUtterance(string: strValue)
        switch strSelectedLanguage {
        case "English":
            strLanguage = "en-US"
            break
        case "Hindi":
            strLanguage = "hi-IN"
            break
        case "Gujarati":
            strLanguage = "gu-IN"
            break
        default:
            strLanguage = "en-US"
        }
            utterance.voice = AVSpeechSynthesisVoice(language:strLanguage)//"fr-FR"//en-US//gu_IN//gu-IN//hi-IN
            synth.speak(utterance)
            utterance.rate = 0.01
        }
    }
}
