//
//  OneMUC.swift
//  OneChat
//
//  Created by Paul on 03/03/2015.
//  Copyright (c) 2015 ProcessOne. All rights reserved.
//

import Foundation
import XMPPFramework

typealias OneRoomCreationCompletionHandler = (_ sender: XMPPRoom) -> Void

protocol OneRoomDelegate {
    //func onePresenceDidReceivePresence()
}

class OneRoom: NSObject {
    init(xmppWraper:XMPPWraper) {
        self.xmppWraper = xmppWraper
    }
    let xmppWraper:XMPPWraper
    
    var delegate: OneRoomDelegate?
    
    //Handle nickname changes
    func createRoom(roomJID: String, delegate: AnyObject? = nil) {
        
        let roomMemoryStorage = XMPPRoomMemoryStorage()
        let roomJID = XMPPJID(string:roomJID)
        let xmppRoom = XMPPRoom(roomStorage: roomMemoryStorage, jid: roomJID, dispatchQueue: DispatchQueue.main)
        
        xmppRoom?.activate(xmppWraper.xmppStream)
        xmppRoom?.addDelegate(delegate, delegateQueue: DispatchQueue.main)
        xmppRoom?.join(usingNickname: xmppWraper.xmppStream.myJID.bare(), history: nil, password: nil)
        xmppRoom?.fetchConfigurationForm()
    }
}

extension OneRoom: XMPPRoomDelegate {
    public func xmppRoomDidCreate(_ sender: XMPPRoom!) {
        print(#function)
        print(sender)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, didFetchConfigurationForm configForm: DDXMLElement!) {
        print(#function)
        print(configForm)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, willSendConfiguration roomConfigForm: XMPPIQ!) {
        print(#function)
        print(roomConfigForm)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, didConfigure iqResult: XMPPIQ!) {
        print(#function)
        print(iqResult)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, didNotConfigure iqResult: XMPPIQ!) {
        print(#function)
        print(iqResult)
    }
    
    public func xmppRoomDidJoin(_ sender: XMPPRoom!) {
        print(#function)
        print(sender)
    }
    
    public func xmppRoomDidLeave(_ sender: XMPPRoom!) {
        print(#function)
        print(sender)
    }
    
    public func xmppRoomDidDestroy(_ sender: XMPPRoom!) {
        print(#function)
        print(sender)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, didFailToDestroy iqError: XMPPIQ!) {
        print(#function)
        print(iqError)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, occupantDidJoin occupantJID: XMPPJID!, with presence: XMPPPresence!) {
        print(#function)
        print(occupantJID)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, occupantDidLeave occupantJID: XMPPJID!, with presence: XMPPPresence!) {
        print(#function)
        print(occupantJID)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, occupantDidUpdate occupantJID: XMPPJID!, with presence: XMPPPresence!) {
        print(#function)
        print(occupantJID)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, didReceive message: XMPPMessage!, fromOccupant occupantJID: XMPPJID!) {
        print(#function)
        print(occupantJID)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, didFetchBanList items: [Any]!) {
        print(#function)
        print(items)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, didNotFetchBanList iqError: XMPPIQ!) {
        print(#function)
        print(iqError)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, didFetchMembersList items: [Any]!) {
        print(#function)
        print(items)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, didNotFetchMembersList iqError: XMPPIQ!) {
        print(#function)
        print(iqError)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, didFetchModeratorsList items: [Any]!) {
        print(#function)
        print(items)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, didNotFetchModeratorsList iqError: XMPPIQ!) {
        print(#function)
        print(iqError)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, didEditPrivileges iqResult: XMPPIQ!) {
        print(#function)
        print(iqResult)
    }
    
    public func xmppRoom(_ sender: XMPPRoom!, didNotEditPrivileges iqError: XMPPIQ!) { 
        print(#function)
        print(iqError)
    }
    
    public func xmppRoomDidChangeSubject(_ sender: XMPPRoom!) { 
        print(#function)
        print(sender)
    }
}
