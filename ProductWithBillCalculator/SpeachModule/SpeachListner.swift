//
//  SpeachListner.swift
//  SpeeachRecornizer
//
//  Created by devang bhavsar on 04/01/22.
//

import UIKit
import AVFoundation
import Speech
import Localize_Swift

class SpeachListner: NSObject {
    var arrViewControllerName = [String]()
    var arrOpenViewControllerName = [String]()
    var speechRecognizer:SFSpeechRecognizer?//en-US//hi-IN
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    //var recordButton: UIButton!
    let audioEngine = AVAudioEngine()
    let synth = AVSpeechSynthesizer()
    let userDefault = UserDefaults.standard
    var viewController:UIViewController?
    //var selectedWord:TaSelectedWord?
    var selectedString:TaSelectedValueSuccess?
    static var objShared = SpeachListner()
    var isFirstTimeCall:Bool = true
    var isStopCall:Bool = true
    var strLastValue:String = ""
    private override init() {
        
    }
    
    func setUpData(viewController:UIViewController) {
        self.viewController = viewController
        print("Speech to text = \(strSelectedLocal)")
        guard  let sr = SFSpeechRecognizer(locale: Locale(identifier: strSelectedLocal)) else {
            Alert().showAlert(message: "Local langauge is not suppoeted by Apple choose other langauge".localized(), viewController: viewController)
            return
        }
        sr.delegate = self
        speechRecognizer = sr
        self.setUpValueNameList()
        isFirstTimeCall = true
        Navigation.objShared.isFirstTime = true
        OpenListNavigation.objShared.isFirstTime = true
        SFSpeechRecognizer.requestAuthorization { authStatus in
            // Divert to the app's main thread so that the UI
            // can be updated.
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                break
                case .denied:
                    break
                case .restricted:
                break
                case .notDetermined:
                    break
                default:
                break
                }
            }
        }
    }
    
    func setUpValueNameList() {
        arrViewControllerName.removeAll()
        arrOpenViewControllerName.removeAll()
        arrViewControllerName.append(SideMenuTitle.home.selectedString())
        arrViewControllerName.append(SideMenuTitle.item.selectedString())
        arrViewControllerName.append(SideMenuTitle.customer.selectedString())
        arrViewControllerName.append(SideMenuTitle.organization.selectedString())
        arrViewControllerName.append(SideMenuTitle.licence.selectedString())
        arrViewControllerName.append(SideMenuTitle.account.selectedString())
        arrViewControllerName.append(SideMenuTitle.bill.selectedString())
        arrViewControllerName.append(SideMenuTitle.order.selectedString())
        arrViewControllerName.append(SideMenuTitle.payerQR.selectedString())
        arrViewControllerName.append(SideMenuTitle.privacy.selectedString())
        arrViewControllerName.append(SideMenuTitle.terms.selectedString())
        arrViewControllerName.append(SideMenuTitle.apple.selectedString())
        arrViewControllerName.append(SideMenuTitle.setting.selectedString())
        arrViewControllerName.append(SideMenuTitle.event.selectedString())
        arrViewControllerName.append(SideMenuTitle.profile.selectedString())
        arrViewControllerName.append(SideMenuTitle.password.selectedString())
        
        arrOpenViewControllerName.append(OpenMenuTitle.addProduct.selectedString())
        arrOpenViewControllerName.append(OpenMenuTitle.addItem.selectedString())
        arrOpenViewControllerName.append(OpenMenuTitle.addCustomer.selectedString())
        arrOpenViewControllerName.append(OpenMenuTitle.addLicence.selectedString())
        arrOpenViewControllerName.append(OpenMenuTitle.addOrderDetail.selectedString())
        arrOpenViewControllerName.append(OpenMenuTitle.addPayerQR.selectedString())
        arrOpenViewControllerName.append(OpenMenuTitle.subScription.selectedString())
    }
    
    func startRecording() throws {
        // Cancel the previous task if it's running.
        recognitionTask?.cancel()
        self.recognitionTask = nil
        
        // Configure the audio session for the app.
        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.record, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
        let inputNode = audioEngine.inputNode

        // Create and configure the speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest = recognitionRequest else { fatalError("Unable to create a SFSpeechAudioBufferRecognitionRequest object") }
        recognitionRequest.shouldReportPartialResults = true
        
        // Keep speech recognition data on device
        if #available(iOS 13, *) {
            recognitionRequest.requiresOnDeviceRecognition = false
        }
        
        // Create a recognition task for the speech recognition session.
        // Keep a reference to the task so that it can be canceled.
        guard let speechRecognizerData = speechRecognizer else {
            DispatchQueue.main.async {
                Alert().showAlert(message: "Local langauge is not suppoeted by Apple choose other langauge".localized(), viewController: self.viewController!)
            }
            return
        }
        recognitionTask = speechRecognizerData.recognitionTask(with: recognitionRequest) { result, error in
            var isFinal = false
            
            if let result = result {
                isFinal = result.isFinal
                let newData = result.bestTranscription.formattedString
                let split = newData.split(separator: " ")
                let lastFour = String(split.suffix(2).joined(separator: [" "]))
                print("Text \(lastFour)")
                if lastFour.count > 1  && !lastFour.lowercased().contains("go to".localized()) && !lastFour.lowercased().contains("open".localized())  {
                    self.selectedString!(lastFour)
                }
            }
            if  self.isFirstTimeCall {
                if let result = result {
                    let newData = result.bestTranscription.formattedString
                    let split = newData.split(separator: " ")
                    let lastTwo = String(split.suffix(3).joined(separator: [" "]))
                    if lastTwo.lowercased().contains("go to".localized()) || lastTwo.lowercased().contains("जाओ") {
                       // self.setUpStopData()
                        self.moveToNextViewController(strValue: lastTwo)
                    } else if lastTwo.lowercased().contains("open".localized()) || lastTwo.lowercased().contains("खोले") || lastTwo.lowercased().contains("खुले"){
                        //self.setUpStopData()
                        self.openViewController(strValue: lastTwo)
                       // self.openViewController(arrAllData: newData)
                    }
                    if result.bestTranscription.formattedString.lowercased().contains("Stop".localized().lowercased()) {
                        if self.isStopCall {
                            self.isStopCall = false
                            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "speak is stop now If you want to start then change the Speech setup from setting".localized())
                            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                                self.isStopCall = true
                            }
                        }
                        self.userDefault.set(false, forKey: kSpeakSpeech)
                        self.userDefault.synchronize()
                        self.setUpStopData()
                    }
                    if result.bestTranscription.formattedString.lowercased().contains("Start".localized().lowercased()) {
                        self.setUpSpeackRecognizer()
                    }
                }
            }
            if error != nil || isFinal {
                // Stop recognizing speech if there is a problem.
                if error != nil {
                    if error!.localizedDescription.contains("kAFAssistantErrorDomain error 4") {
                        //let data = error!.localizedDescription.components(separatedBy: "domain")
                        Alert().showAlert(message: "Check the internet conection", viewController: self.viewController!)
                        SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Check the internet conection".localized())
                    } else if error!.localizedDescription.contains("kAFAssistantErrorDomain Code=209") {
                        SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "issue in start the speak wait until this message is not repeat then click on speak".localized())
                    }
                }
                self.audioEngine.stop()
                inputNode.removeTap(onBus: 0)
                self.recognitionRequest = nil
                self.recognitionTask = nil
            }
        }

        // Configure the microphone input.
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer: AVAudioPCMBuffer, when: AVAudioTime) in
            self.recognitionRequest?.append(buffer)
        }
        audioEngine.prepare()
        try audioEngine.start()
        // Let the user know to start talking.
       // textView.text = "(Go ahead, I'm listening)"
    }
    
    func moveToNextViewController(strValue:String) {
        let split = strValue.split(separator: " ")
        var value = String(split.suffix(1).joined(separator: [" "]))
        print("value = \(value)")
        if value.contains("Setting".lowercased().localized()) {
            value = "Setting".lowercased().localized()
        }
        DispatchQueue.main.async {
            if self.arrViewControllerName.contains(value.lowercased()) && value.count > 1 {
                self.isFirstTimeCall = false
                print("All data count value")
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self.strLastValue = ""
                    self.isFirstTimeCall = true
                    Navigation.objShared.isFirstTime = true
                }
                Navigation.objShared.checkForMoveData(strData: value.lowercased(), viewController: self.viewController!)
            }
        }
    }
    func openViewController(strValue:String) {
        
        let split = strValue.split(separator: " ")
        let value = String(split.suffix(1).joined(separator: [" "]))
        print("value = \(value)")
        DispatchQueue.main.async {
            if self.strLastValue != value {
                if self.arrOpenViewControllerName.contains(value.lowercased()) && value.count > 1 {
                    self.strLastValue = value
                    self.isFirstTimeCall = false
                    print("All data count value")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                        self.strLastValue = ""
                        self.isFirstTimeCall = true
                        OpenListNavigation.objShared.isFirstTime = true
                    }
                    OpenListNavigation.objShared.checkForOpenData(strData: value.lowercased(), viewController: self.viewController!)
                }
            }

        }
    }
    
    func setUpSpeackRecognizer() {
        let value = userDefault.value(forKey: kSpeakSpeech) as! Bool
        if value {
            if self.audioEngine.isRunning {
                audioEngine.inputNode.removeTap(onBus: 0)
                self.audioEngine.stop()
                self.recognitionRequest?.endAudio()
                do {
                    try self.startRecording()
                } catch {
                    Alert().showAlert(message: "please try again", viewController: viewController!)
                }
                
            } else {
                do {
                    try self.startRecording()
                } catch {
                    Alert().showAlert(message: "please try again", viewController: viewController!)
                }
            }
        } else {
            DispatchQueue.main.async {
                Alert().showAlert(message: "Prefer".localized() + " " + "Setting".localized(), viewController: self.viewController!)
                return
            }
        }
    }
    
    func setUpStopData() {
        self.audioEngine.stop()
        self.recognitionRequest?.endAudio()
        audioEngine.inputNode.removeTap(onBus: 0)
        self.recognitionRequest = nil
        self.recognitionTask = nil
    }
}
extension SpeachListner:SFSpeechRecognizerDelegate {
    public func speechRecognizer(_ speechRecognizer: SFSpeechRecognizer, availabilityDidChange available: Bool) {
        if available {
            //self.selectedString!("Start Recording".localized())
        } else {
            self.selectedString!("Recognition Not Available")
        }
    }
}
