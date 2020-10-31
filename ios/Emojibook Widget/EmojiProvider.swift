//
//  EmojiProvider.swift
//  Emojibook WidgetExtension
//
//  Created by Chiziaruhoma Ogbonda on 31/10/2020.
//

import Foundation

public struct EmojiProvider {
    static func random() -> EmojiDetails {
        
        let sharedDefaults = UserDefaults.init(suiteName: "group.iosWidgetDemo")
        if sharedDefaults != nil {
                    do{
                        let emoji = sharedDefaults?.string(forKey: "emoji") ?? "🚀"
                        let name = sharedDefaults?.string(forKey: "name") ?? "Rocket"
                        let description = sharedDefaults?.string(forKey: "description") ?? "A rocket being propelled into space."
                      
                        return EmojiDetails(
                            emoji: emoji,
                            name: name,
                            description: description
                        )
                    }
        }else{
            return EmojiDetails(
                emoji:  "🚀",
                name: "Rocket",
                description: "A rocket being propelled into space."
            )
        }
                
      
    }
}
