//
//  AlertViewController.swift
//  HEXv2
//
//  Created by Alec Isherwood on 06/07/2021.
//

import UIKit

class BANAlertViewController: UIViewController {
    
    let alertyTitleLbl      = UILabel()
    let alertyMessageLbl    = UILabel()
    let alertyIcon          = UIImageView()
    let alertyCloseBtn      = UIButton()

    var alertTitle:String = "Oops!"
    var alertMessage:String = "We're very sorry. Something went wrong."
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
//        view.backgroundColor = .red
        
        alertyIcon.image = Bundle.main.app_iconx // UIImage(named: "AlertWindowAppIcon")
        view.addSubview(alertyIcon)
        alertyIcon.util_align_top_anchor(pixel: 10)
        alertyIcon.util_width_anchor(pixel: 70)
        alertyIcon.util_height_anchor(pixel: 80)
        alertyIcon.util_align_center_x_anchor()
        
        
        
        alertyTitleLbl.text = alertTitle
        alertyTitleLbl.textAlignment = .center
        alertyTitleLbl.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        alertyTitleLbl.numberOfLines = 0
        alertyTitleLbl.adjustsFontSizeToFitWidth = true
        view.addSubview(alertyTitleLbl)
        alertyTitleLbl.util_align_top_anchor_to_bottom_of_view(view: alertyIcon, pixel: 5)
        alertyTitleLbl.util_align_left_anchor(pixel: 10)
        alertyTitleLbl.util_align_right_anchor(pixel: 10)
        
        
        alertyMessageLbl.text = alertMessage
        alertyMessageLbl.textAlignment = .center
        alertyMessageLbl.font = UIFont.systemFont(ofSize: 13, weight: .regular)
        alertyMessageLbl.numberOfLines = 0
        alertyMessageLbl.adjustsFontSizeToFitWidth = true
        view.addSubview(alertyMessageLbl)
        alertyMessageLbl.util_align_top_anchor_to_bottom_of_view(view: alertyTitleLbl, pixel: 5)
        alertyMessageLbl.util_align_left_anchor(pixel: 10)
        alertyMessageLbl.util_align_right_anchor(pixel: 10)
        

        if BANPlatform.isCatalyst == true {
            self.alertyCloseBtn.setTitle("OK", for: .normal)
        }
        alertyCloseBtn.layer.cornerRadius = 5
        alertyCloseBtn.setBackgroundImage(UIColor.systemFill.image(), for: .normal)
        alertyCloseBtn.setBackgroundImage(UIColor.secondarySystemFill.image(), for: .highlighted)
        alertyCloseBtn.clipsToBounds = true
        alertyCloseBtn.addTarget(self, action: #selector(closeAlert), for: .touchUpInside)
        view.addSubview(alertyCloseBtn)
        alertyCloseBtn.util_align_top_anchor_to_bottom_of_view(view: alertyMessageLbl, pixel: 15)
        alertyCloseBtn.util_width_anchor(pixel: 120)
        alertyCloseBtn.util_height_anchor(pixel: 30)
        alertyCloseBtn.util_align_center_x_anchor()

        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        func bitSet(_ bits: [Int]) -> UInt {
            return bits.reduce(0) { $0 | (1 << $1) }
        }

        func property(_ property: String, object: NSObject, set: [Int], clear: [Int]) {
            if let value = object.value(forKey: property) as? UInt {
                object.setValue((value & ~bitSet(clear)) | bitSet(set), forKey: property)
            }
        }

        // disable full-screen button
        if  let NSApplication = NSClassFromString("NSApplication") as? NSObject.Type,
            let sharedApplication = NSApplication.value(forKeyPath: "sharedApplication") as? NSObject,
            let windows = sharedApplication.value(forKeyPath: "windows") as? [NSObject]
        {
            for window in windows {
                let resizable = 3
                property("styleMask", object: window, set: [], clear: [resizable])
                let fullScreenPrimary = 7
                let fullScreenAuxiliary = 8
                let fullScreenNone = 9
                property("collectionBehavior", object: window, set: [fullScreenNone], clear: [fullScreenPrimary, fullScreenAuxiliary])
            }
        }
    }
    
    @objc func closeAlert() {
        if let sceneSession = view.window?.windowScene?.session {
            let options = UIWindowSceneDestructionRequestOptions()
            options.windowDismissalAnimation = .standard
            BANSceneManager.close_scene(sceneSession)
        }
    }

    
}
