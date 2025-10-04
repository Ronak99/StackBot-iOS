//
//  secrets.swift
//  StackBot
//
//  Created by Ronak Punase on 03/10/25.
//

import Foundation

enum Secrets {
    static var openAIApiKey: String {
        guard let key = Bundle.main.infoDictionary?["OPENAI_API_KEY"] as? String else {
            fatalError("OPEN_AI_API_KEY not found in Info.plist")
        }
        return key
    }
    
    static var orgKey: String {
        guard let key = Bundle.main.infoDictionary?["OPENAI_ORG_KEY"] as? String else {
            fatalError("OPEN_AI_ORG_KEY not found in Info.plist")
        }
        return key
    }
}
