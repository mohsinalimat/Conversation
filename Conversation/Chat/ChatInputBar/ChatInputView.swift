//
//  ChatInputView.swift
//  Conversation
//
//  Created by Aung Ko Min on 30/1/22.
//

import SwiftUI

struct ChatInputView: View {
    
    @EnvironmentObject private var datasource: ChatDatasource
    @EnvironmentObject private var chatLayout: ChatLayout
    @EnvironmentObject private var msgCreater: MsgCreator
    @EnvironmentObject private var msgSender: MsgSender
    @EnvironmentObject private var inputManager: ChatInputViewManager
    
    
    var body: some View {
        
        VStack() {
            HStack(alignment: .bottom) {
                LeftMenuButton()
                InputTextView()
                    .frame(maxHeight: chatLayout.textViewHeight)
                    .background(Color(uiColor: .systemBackground).cornerRadius(10))
                SendButton()
            }
            pickerView()
        }
        .padding(7)
        .background(.ultraThickMaterial)
        .saveBounds(viewId: 1, coordinateSpace: .named("chatScrollView"))
    }
    
    private func pickerView() -> some View {
        return Group {
            switch inputManager.currentInputItem {
            case .ToolBar:
                InputToolbar()
            case .Location:
                LocationPicker()
            case .None:
                EmptyView()
            default:
                VStack {
                    Text(String(describing: inputManager.currentInputItem))
                }
                .frame(maxWidth: .infinity)
                .aspectRatio(1, contentMode: .fill)
            }
        }
    }
}