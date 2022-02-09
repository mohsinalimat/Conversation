//
//  ImageBubble.swift
//  Conversation
//
//  Created by Aung Ko Min on 31/1/22.
//

import SwiftUI

struct ImageBubble: View {
    
    let data: Msg.MsgType.ImageData
    
    var body: some View {
        
        AsyncImage(
            url: URL(string: data.urlString),
            content: { image in
                image.resizable()
                    .aspectRatio(contentMode: .fit)
            },
            placeholder: {
                ProgressView()
            }
        )
        
    }
}