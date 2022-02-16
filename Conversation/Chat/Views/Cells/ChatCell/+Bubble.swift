//
//  +Bubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 13/2/22.
//

import SwiftUI

extension ChatCell {
    
    internal func bubbleView() -> some View {
        Group {
            if AppUserDefault.shared.canDragCell {
                plainBubbleView()
                    .offset(x: dragOffsetX)
                    .gesture(bubbleTapGesture)
            }else {
                plainBubbleView()
                    .onTapGesture {
                        didTapBubble()
                    }
            }
        }
    }
    
    private func plainBubbleView() -> some View {
        return Group {
            switch msg.msgType {
            case .Text:
                if let data = msg.textData {
                    TextBubble(data: data)
                        .foregroundColor(roomProperties.textColor(for: msg))
                        .background(
                            roomProperties.bubbleColor(for: msg)
                                .clipShape(
                                    BubbleShape(corners: style.bubbleCorner)
                                )
                        )
                        
                }
            case .Image:
                ImageBubble()
            case .Location:
                if let data = msg.locationData {
                    LocationBubble()
                        .frame(size: data.imageSize)
                }
            case .Emoji:
                if let data = msg.emojiData {
                    EmojiBubble(data: data)
                }
            default:
                EmptyView()
            }
        }
        .contextMenu{ MsgContextMenu().environmentObject(msg) }
    }
    private func didTapBubble() {
        Task {
            await ToneManager.shared.vibrate(vibration: .soft)
        }
        withAnimation(.interactiveSpring()) {
            chatLayout.selectedId = chatLayout.selectedId == msg.id ? nil : msg.id
        }
    }
    private var bubbleTapGesture: some Gesture {
        TapGesture(count: 2)
            .onEnded {
                didTapBubble()
            }
            .exclusively(before: bubbleDragGesture)
    }
    
    private var bubbleDragGesture: some Gesture {
        
        DragGesture(minimumDistance: 5, coordinateSpace: .global)
            .onChanged { value in
                guard value.translation.height < 10 else {
                    return
                }
                let offsetX = value.translation.width
                if msg.rType == .Send {
                    if offsetX > 0 {
                        dragOffsetX = 0
                        return
                    }
                    dragOffsetX = offsetX
                } else {
                    if offsetX < 0 {
                        dragOffsetX = 0
                        return
                    }
                    dragOffsetX = offsetX
                }
            }
            .onEnded { value in
                guard dragOffsetX != 0 else { return }
                Task {
                    await ToneManager.shared.playSound(tone: .Tock)
                }
                withAnimation(.interactiveSpring()) {
                    dragOffsetX = 0
                }
            }
    }
}
