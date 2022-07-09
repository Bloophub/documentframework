//
//  TXTPreferenceAppearanceUITableViewController:.swift
//  TextEditor
//
//  Created by Giovanni Simonicca on 7/8/22.
//

import UIKit
import Dynamic

class BANPreferenceAppearanceUITableViewController : BANBaseUITableViewController {
        
        private let cell_identifier =  "TXTPreferenceAppearanceUITableViewControllerCell"
        
        override func viewDidLoad() {
            super.viewDidLoad()
            self.navigationItem.title = "Appearance"
            
        }
        
        
        lazy var data: [BANAppearance] = {
            return [
                BANAppearance.UseSystem,
                BANAppearance.DarkMode,
                BANAppearance.LightMode
            ]
        }()
        
        override func numberOfSections(in tableView: UITableView) -> Int {
            return 1
        }
        
        
        override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return data.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell: UITableViewCell = {
                guard let cell = tableView.dequeueReusableCell(withIdentifier: cell_identifier) else {
                    return UITableViewCell(style: .value1, reuseIdentifier: cell_identifier)
                }
                return cell
            }()
            let row     = indexPath.row
            
            cell.textLabel?.text    = ""
            cell.accessoryType      = .none
            cell.imageView?.image   = nil
            
            
            let data    = data[row]
                
            let pref    =  XPref.get_appearance()
            
            cell.textLabel?.text     = data.get_name()
            if data == pref {
                cell.accessoryType = .checkmark
            }
            
            return cell
        }
            
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let section = indexPath.section
            let row     = indexPath.row
            if(section == 0) {
                
                let data = data[row]
                XPref.set_appearance(data)
                    
                
                func get_style() -> UIUserInterfaceStyle{
                    var a = UIUserInterfaceStyle.unspecified
                    switch data {
                    case .UseSystem:
                        //ks.overrideUserInterfaceStyle = .unspecified
                        // Testing see if split is the once causeing problems
                        a = .unspecified
                        break
                    case .DarkMode:
                        a = .dark
    //                    ks.overrideUserInterfaceStyle = .dark
    //                    split.overrideUserInterfaceStyle = .dark
                        break
                    case .LightMode:
                        a = .light
    //                    ks.overrideUserInterfaceStyle = .light
    //                    split.overrideUserInterfaceStyle = .light
                        break
                    }
                    return a

                }
                let a = get_style()
                
                if(Platform.isPhone){
                    view.window?.overrideUserInterfaceStyle = a
                    return
                }
                
                //if Platform.hasSceneSupport {
    //                guard let all_open_scenes = SceneManager.get_editor_scenes() else {
    //                    ALog.log_verbose("Returned 1")
    //                    return
    //                }
                UIApplication.shared.connectedScenes.forEach { scene in
                    guard let winsc = scene as? UIWindowScene else { return }
                    winsc.windows.forEach { win in
                        
    //                    guard win is DocumentWindow else  { return }
                        
    //                    print("xxxxx xxxxx xxxxx \(a)")
    //                    print("win \(win)")
                        win.overrideUserInterfaceStyle = a
    //                    print("win.rootViewController \(win.rootViewController)")
                        win.rootViewController?.overrideUserInterfaceStyle = a
                    }
                }
                
                #if targetEnvironment(macCatalyst)
                    //https://github.com/mhdhejazi/Dynamic
                    let app = Dynamic.NSApplication.sharedApplication
    //                let cl =  NSClassFromString("NSApplication")

                    var str = ""

                    if a == .unspecified {
                        
                    }
                    else if a == .dark {
                        str = "NSAppearanceNameDarkAqua"
                    }
                    else if a == .light {
                        str = "NSAppearanceNameAqua"
                    }

    //                2022-07-05 22:59:07.547558+0200 HTML Editor[8444:10395764] [SceneConfiguration] Info.plist configuration "Preferences Configuration" for UIWindowSceneSessionRoleApplication contained UISceneClassName key, but could not load class with name "HTML_Editor.PreferencesScene".

                
    //                let da  = Dynamic.NSAppearanceName.darkAqua
                    let appe = Dynamic.NSAppearance.appearanceNamed(str).asObject
                    //Dynamic.NSApplication.sharedApplication.appearance = app
                    app.appearance = appe //NSAppearance(named: .darkAqua)
                #endif

            }
        }
        
        override func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.accessoryType = .none
            }
        }
        
        
        
        override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
            switch section {
            case 0:
                return "Appearance"
            default:
                return ""
            }
        }
        
//        override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
//            switch section {
//            case 0:
//                return "This will switch te app to the color mode you prefer. You can either specify dark or light mode. Alternatively, let the keyboard follow your iPhone settings."
//            default:
//                return ""
//            }
//        }
//        
//        func resetChecks() {
//            for i in 0..<tableView.numberOfSections {
//                for j in 0..<tableView.numberOfRows(inSection: i) {
//                    if let cell = tableView.cellForRow(at: IndexPath(row: j, section: i)) {
//                        cell.accessoryView = .none
//                    }
//                }
//            }
//        }
        
    }
