//
//  VCAPreferenceUIViewController.swift
//  VCam
//
//  Created by Giovanni Simonicca on 7/2/22.
//

import Foundation
import UIKit

class BANPreferenceUITableViewController: BANBaseUITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if !Platform.isCatalyst {
            self.title = "Settings"
        }
        if !Platform.isCatalyst, presentingViewController != nil {
            self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(close_controller))
        }


    }
    
    @objc func close_controller(_ btn: UIBarButtonItem){
        self.dismiss(animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "General"
    }
    
    private let cellReuseIdentifier = "TXTPreferenceUITableViewControllerCell"
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create a new cell if needed or reuse an old one
        var cell = self.tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)
        if cell == nil {
            cell = UITableViewCell(style: .value1, reuseIdentifier: cellReuseIdentifier)
        }
        guard let cellx = cell else { return UITableViewCell() }
        cellx.selectionStyle        = .default
        cellx.accessoryType         = .none
        cellx.accessoryView         = nil
        cellx.textLabel?.text       = ""
        cellx.detailTextLabel?.text = ""
        // set the text from the data model
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cellx.selectionStyle        = .none
                cellx.textLabel?.text       = "Appearance"
                cellx.accessoryType         = .disclosureIndicator
            }
        }
        return cellx
        
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            if indexPath.row == 0 {
                let vc  = BANPreferenceAppearanceUITableViewController(style: .insetGrouped)
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
//
//    @objc private func switchbtn_line_number_act(_ btn : UISwitch){
//        guard let pref = XPref.get_editor_preference() else { return }
//        pref.lineNumbers = btn.isOn ? "on" : "off"
//        XPref.set_editor_preference(pref)
//    }
//    
//    @objc private func switchbtn_links_act(_ btn : UISwitch){
//        guard let pref = XPref.get_editor_preference() else { return }
//        pref.links = btn.isOn
//        XPref.set_editor_preference(pref)
//    }
//    
//    @objc private func switchbtn_match_brackets_act(_ btn : UISwitch){
//        guard let pref = XPref.get_editor_preference() else { return }
//        pref.matchBrackets = btn.isOn  ? "always" : "never"
//        XPref.set_editor_preference(pref)
//    }
}
