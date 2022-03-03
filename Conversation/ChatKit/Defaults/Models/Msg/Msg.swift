//
//  Msg.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI
import CoreLocation
import Combine

class Msg: ObservableObject, Identifiable {
    
    var id: String
    let conId: String
    var rType: RecieptType
    var msgType: MsgType
    var date: Date
    
    var progress: MsgProgress
    
    var sender: MsgSender
    var textData: MsgType.TextData?
    
    @Published var imageData: MsgType.ImageData?
    var videoData: MsgType.ViedeoData?
    var locationData: MsgType.LocationData?
    var emojiData: MsgType.EmojiData?
    var attachmentData: MsgType.AttachmentData?
    var voiceData: MsgType.VoiceData?
    
    var imageRatio: Double
    var bubbleSize: CGSize?
    
    // RCMsg
    var userId = ""
    var userFullname = ""
    var userInitials = ""
    var userPictureAt: TimeInterval = 0

    var videoDuration = 0
    var audioDuration = 0

    var latitude: CLLocationDegrees = 0
    var longitude: CLLocationDegrees = 0

    var isDataQueued = false
    var isMediaQueued = false
    var isMediaFailed = false
    var isMediaOrigin = false

    var createdAt: TimeInterval = 0

    var incoming = false
    var outgoing = false

    var videoPath: String?
    var audioPath: String?
    
    var stickerImage: UIImage?
    var videoThumbnail: UIImage?
    var locationThumbnail: UIImage?

    var audioStatus = AudioStatus.Stopped
    @Published var mediaStatus = MediaStatus.Unknown

    var audioCurrent: TimeInterval = 0

    init(conId: String, msgType: MsgType, rType: RecieptType, progress: MsgProgress) {
        self.id = UUID().uuidString
        self.conId = conId
        self.rType = rType
        self.date = Date()
        self.progress = progress
        self.msgType = msgType
        self.sender = rType == .Send ? CurrentUser.shared.user : .init(id: "2", name: "Jonah", photoURL: "")
        self.imageRatio = 1
    }
    
    convenience init(conId: String, textData: Msg.MsgType.TextData, rType: RecieptType, progress: MsgProgress) {
        self.init(conId: conId, msgType: .Text, rType: rType, progress: progress)
        self.textData = textData
    }
    convenience init(conId: String, imageData: Msg.MsgType.ImageData, rType: RecieptType, progress: MsgProgress) {
        self.init(conId: conId, msgType: .Image, rType: rType, progress: progress)
        self.imageData = imageData
    }
    convenience init(conId: String, videoData: Msg.MsgType.ViedeoData, rType: RecieptType, progress: MsgProgress) {
        self.init(conId: conId, msgType: .Video, rType: rType, progress: progress)
        self.videoData = videoData
    }
    convenience init(conId: String, locationData: Msg.MsgType.LocationData, rType: RecieptType, progress: MsgProgress) {
        self.init(conId: conId, msgType: .Location, rType: rType, progress: progress)
        self.locationData = locationData
    }
    convenience init(conId: String, emojiData: Msg.MsgType.EmojiData, rType: RecieptType, progress: MsgProgress) {
        self.init(conId: conId, msgType: .Emoji, rType: rType, progress: progress)
        self.emojiData = emojiData
    }
    convenience init(conId: String, attachmentData: Msg.MsgType.AttachmentData, rType: RecieptType, progress: MsgProgress) {
        self.init(conId: conId, msgType: .Attachment, rType: rType, progress: progress)
        self.attachmentData = attachmentData
    }
    convenience init(conId: String, voiceData: Msg.MsgType.VoiceData, rType: RecieptType, progress: MsgProgress) {
        self.init(conId: conId, msgType: .Voice, rType: rType, progress: progress)
        self.voiceData = voiceData
    }
    
    
    init(cMsg: CMsg) {
        
        let rType = Msg.RecieptType(rawValue: cMsg.rType)!
        let msgType = Msg.MsgType(rawValue: cMsg.msgType)!
        let sender = MsgSender(id: cMsg.senderID!, name: cMsg.senderName!, photoURL: cMsg.senderURL!)
        let progress = Msg.MsgProgress(rawValue: cMsg.progress)!
        
        self.id = cMsg.id ?? UUID().uuidString
        self.conId = cMsg.conId ?? UUID().uuidString
        self.rType = rType
        self.msgType = msgType
        self.date = cMsg.date!
        self.sender = sender
        self.progress = progress
        self.imageRatio = cMsg.imageRatio
        
        let txt = cMsg.data ?? ""
        
        switch msgType {
        case .Text:
            self.textData  = .init(text: txt)
        case .Image:
            self.imageData = .init()
        case .Video:
            self.videoData = .init(duration: 0)
        case .Location:
            self.locationData = .init(latitude: cMsg.lat, longitude: cMsg.long)
        case .Emoji:
            let random = CGFloat.random(in: 30..<150)
            self.emojiData = .init(emojiID: txt, size: .init(width: random, height: random))
        case .Attachment:
            self.attachmentData = .init(urlString: txt)
        case .Voice:
            self.voiceData = .init()
        }
    }
}

extension Msg: Equatable {
    static func == (lhs: Msg, rhs: Msg) -> Bool {
        lhs.id == rhs.id
    }
}
extension Msg: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self)
    }
}