//
//  ImageDisplayViewController.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 20/03/21.
//

import UIKit
import Floaty

class ImageDisplayViewController: UIViewController {

    @IBOutlet weak var viewHeader: UIView!
    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var viewCorner: UIView!
    @IBOutlet weak var imgView: UIImageView!
    
    @IBOutlet weak var btnDelete: UIButton!
    var isFromBillDisplay:Bool = false
    var objImageDisplay = ImageDisplayViewModel()
    var imageData = Data()
    var floaty = Floaty()
    var updateClosure:updateDataWhenBackClosure?
    @IBOutlet weak var imgPaied: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        btnDelete.isHidden = true
        btnDelete.tintColor = hexStringToUIColor(hex: strTheamColor)
        imgPaied.isHidden = true
        objImageDisplay.setHeaderView(headerView: self.viewHeader)
        self.configureData()
    }
    override func viewDidAppear(_ animated: Bool) {
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
    }
    func configureData(){
        viewBackground.backgroundColor = hexStringToUIColor(hex: strTheamColor)
        viewCorner.roundCorners(corners: [.topLeft,.topRight], radius: cornderRadious)
        if !isFromBillDisplay {
            self.imgView.image = UIImage(data: imageData)
        } else {
            btnDelete.isHidden = false
            objImageDisplay.fetchProductDetailList()
            objImageDisplay.setupData(imageView: imgView, paiedImage: imgPaied)
            self.layoutFAB()
        }
    }
    @objc func backClicked() {
        updateClosure!()
        self.dismiss(animated: true, completion: nil)
        OpenListNavigation.objShared.viewController.viewDidAppear(true)
    }
    @IBAction func btnDeleteClicked(_ sender: Any) {
        if imgPaied.isHidden == false {
            setAlertWithCustomAction(viewController: self, message: kDeleteMessage.localized(), ok: { (isSuccess) in
                self.objImageDisplay.deleteFromDatabase(view: self.view) { (isSuccess) in
                    if isSuccess {
                        self.updateClosure!()
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        Alert().showAlert(message: "please try again after some time".localized(), viewController: self)
                    }
                }
            }, isCancel: true) { (isFailed) in
            }
        } else {
            Alert().showAlert(message: "if bill is paied then only you can delete the bill".localized(), viewController: self)
        }

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
