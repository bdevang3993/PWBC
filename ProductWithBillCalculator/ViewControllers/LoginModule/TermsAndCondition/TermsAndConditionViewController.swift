//
//  TermsAndConditionViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 19/08/21.
//

import UIKit
import WebKit
import Floaty

class TermsAndConditionViewController: UIViewController {
    @IBOutlet weak var txtViewDisplay: UITextView!
    @IBOutlet weak var imgCheckBox: UIImageView!
    @IBOutlet weak var lblTerms: UILabel!
    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackGround: UIView!
    @IBOutlet weak var btnTermsofUse: UIButton!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var webview: WKWebView!
    var isFromEULA:Bool = false
    var isfromPrivacy:Bool = true
    var isfromBack:Bool = false
    var strURL = "https://pages.flycricket.io/pwbc/terms.html"
    var strEULA = "https://www.apple.com/legal/internet-services/itunes/dev/stdeula/"
    let objTermsAndConditionViewModel = TermsAndConditionViewModel()
    var floaty = Floaty()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configureData()
        if isSpeackSpeechOn {
            SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Moved".localized())
            SpeachListner.objShared.setUpStopData()
            MBProgressHub.showLoadingSpinner(sender: self.view)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
       
        //   viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        if isSpeackSpeechOn {
            SpeachListner.objShared.setUpData(viewController: self)
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                self.setUpSpeechData()
                MBProgressHub.dismissLoadingSpinner(self.view)
                SpeachRecognizerData.objShared.setupValueForSpeak(strValue: "Speak".localized())
            }
        }
    }
    
    func configureData() {
        webview.navigationDelegate = self
//        viewBackGround.backgroundColor = hexStringToUIColor(hex: strTheamColor)
//        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        objTermsAndConditionViewModel.setHeaderView(headerView: viewHeader, isFromBack: isfromBack, isPrivacy: isfromPrivacy, isFromEULA: isFromEULA)
        //txtViewDisplay.attributedText = strHtml.htmlToAttributedString
        var fontSize:CGFloat = 20.0
         if UIDevice.current.userInterfaceIdiom == .pad {
            fontSize = 40.0
         }
        
        if isfromPrivacy {
            strURL = "https://pages.flycricket.io/pwbc/privacy.html"
        }
        if isFromEULA {
            strURL = strEULA
        }
        webview.navigationDelegate = self
        let url = URL(string: strURL)!
        webview.load(URLRequest(url: url))
        webview.autoresizingMask = [.flexibleWidth,.flexibleHeight]
        webview.allowsBackForwardNavigationGestures = true
        self.layoutFAB()
    }
//    @IBAction func btnTermsOfUseClicked(_ sender: Any) {
//        let url = URL(string: "https://pages.flycricket.io/pwbc/terms.html")
//        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
//        imgCheckBox.image = UIImage(named: "checked")
//    }
//    func  checkForData() -> Bool{
//        let image = UIImage(named: "unChecked")
//        let compare = imgCheckBox.image?.isEqualToImage(image: image!)
//        if compare! {
//            Alert().showAlert(message: "please check out for terms and uses", viewController: self)
//            return false
//        } else {
//            return true
//        }
//    }
    @objc func backClicked() {
        self.dismiss(animated: true, completion: nil)
//        if checkForData() {
//            self.dismiss(animated: true, completion: nil)
//        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension TermsAndConditionViewController:WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        if navigationAction.navigationType == .linkActivated  {
            if let url = navigationAction.request.url,
                let host = url.host, !host.hasPrefix("www.google.com"),
                UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                print(url)
                decisionHandler(.cancel)
            } else {
                decisionHandler(.allow)
            }
        } else {
            decisionHandler(.allow)
        }
    }
}
