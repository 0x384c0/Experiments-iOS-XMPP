//
//  XMPPWraper.swift
//  Experiments-iOS-XMPP
//
//  Created by 0x384c0 on 10.04.17.
//  Copyright © 2017 0x384c0. All rights reserved.
//

import XMPPFramework


class XMPPWraper : NSObject, XMPPRosterDelegate, XMPPStreamDelegate{
    let
    xmppStream = XMPPStream()!,
    xmppRosterStorage = XMPPRosterCoreDataStorage(),
    jabberID:String,
    userPassword:String
    var
    delegate:ChatDelegate! = nil,
    xmppRoster: XMPPRoster
    init(jabberID:String, userPassword:String) {
        self.jabberID = jabberID
        self.userPassword = userPassword
        xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)
        DDLog.add(DDTTYLogger.sharedInstance)
        super.init()
        setupStream()
    }
    
    //MARK: Private Methods
    private func setupStream() {
        //xmppRoster = XMPPRoster(rosterStorage: xmppRosterStorage)
        xmppRoster.activate(xmppStream)
        xmppStream.addDelegate(self, delegateQueue: DispatchQueue.main)
        xmppRoster.addDelegate(self, delegateQueue: DispatchQueue.main)
    }
    private func goOnline() {
        let presence = XMPPPresence()
        let domain = xmppStream.myJID.domain
        
        if domain == "gmail.com" || domain == "gtalk.com" || domain == "talk.google.com" {
            let priority = DDXMLElement.element(withName: "priority", stringValue: "24") as! DDXMLElement
            presence?.addChild(priority)
        }
        xmppStream.send(presence)
    }
    private func goOffline() {
        let presence = XMPPPresence(type: "unavailable")
        xmppStream.send(presence)
    }
    
    func connect() -> Bool {
        if !xmppStream.isConnected() {
            
            if !xmppStream.isDisconnected() {
                return true
            }
            xmppStream.myJID = XMPPJID(string: jabberID)
            
            do {
                try xmppStream.connect(withTimeout: XMPPStreamTimeoutNone)
                print("Connection success")
                return true
            } catch {
                print("Something went wrong!")
                return false
            }
        } else {
            return true
        }
    }
    func disconnect() {
        goOffline()
        xmppStream.disconnect()
    }
    
    //MARK: XMPP Delegates
    //XMPPStreamDelegate
    func xmppStreamDidConnect(_ sender: XMPPStream!) {
        do {
            try	xmppStream.authenticate(withPassword: userPassword)
        } catch {
            print("Could not authenticate")
        }
    }
    func xmppStreamDidAuthenticate(_ sender: XMPPStream!) {
        goOnline()
    }
    func xmppStreamDidChangeMyJID(_ xmppStream: XMPPStream!) {
        print(#function)
        print(xmppStream)
    }
    //XMPPRosterDelegate
    
    
    func xmppStream(_ sender: XMPPStream!, didReceive iq: XMPPIQ!) -> Bool {
        print(#function)
        print(iq)
        return false
    }
    func xmppStream(_ sender: XMPPStream!, didReceive message: XMPPMessage!) {
        print(#function)
        print(message)
        if message.body() != nil{
            delegate.didReceiveMessage(text: message.body())
        }
    }
    func xmppStream(_ sender: XMPPStream!, didSend message: XMPPMessage!) {
        print(#function)
        print(message)
    }
    func xmppStream(_ sender: XMPPStream!, didReceive presence: XMPPPresence!) {
        print(#function)
        print(presence)
        
        let presenceType = presence.type()
        let myUsername = sender.myJID.user
        let presenceFromUser = presence.from().user
        
        if let presenceFromUser = presenceFromUser,
            presenceFromUser != myUsername {
            if presenceType == "available" {
                delegate.buddyWentOnline("\(presenceFromUser)@gmail.com")
            } else if presenceType == "unavailable" {
                delegate.buddyWentOffline("\(presenceFromUser)@gmail.com")
            }
        }
    }
    func xmppRoster(_ sender: XMPPRoster!, didReceiveRosterItem item: DDXMLElement!) {
        print(#function)
        print(item)
    }
}

protocol ChatDelegate {
    func buddyWentOnline(_ name: String)
    func buddyWentOffline(_ name: String)
    func didDisconnect()
    func didReceiveMessage(text:String)
}

