//
//  ViewController.swift
//  Experiments-iOS-XMPP
//
//  Created by 0x384c0 on 10.04.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var passTextField: UITextField!
    @IBOutlet weak var buggiesListLabel: UILabel!
    
    @IBAction func connectTap(_ sender: UIButton) {
        dismissKB()
        buggiesListLabel.text = ""
        if
            let login = loginTextField.text,
            login != "",
            let pass = passTextField.text,
            pass != "" {
            xmppWrapper = XMPPWraper(jabberID: login, userPassword: pass)
            xmppWrapper?.delegate = self
            DispatchQueue.global().async {
                print("Connecting...")
                let result = self.xmppWrapper?.connect()
                print("Connected: \(result)")
            }
        }
    }
    @IBAction func disconnectTap(_ sender: UIButton) {
        dismissKB()
        xmppWrapper?.disconnect()
    }
    
    @IBAction func fetchBuddies(_ sender: UIButton){//contacts
        self.title = xmppWrapper?.xmppStream.myJID.bare()
        
        xmppWrapper?.xmppRoster.fetch()
    }
    
    var xmppWrapper:XMPPWraper?
    
    func dismissKB(){
        loginTextField.resignFirstResponder()
        passTextField.resignFirstResponder()
    }
}

extension ViewController : ChatDelegate{
    func buddyWentOnline(_ name: String){
        print(#function)
        print(name)
        buggiesListLabel.text?.append("\(name)\n")
    }
    func buddyWentOffline(_ name: String){
        print(#function)
        print(name)
    }
    func didDisconnect(){
        print(#function)
    }
}
