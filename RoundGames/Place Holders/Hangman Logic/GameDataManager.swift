//
//  GameDataManager.swift
//  RoundGames
//
//  Created by Michael Roundcount on 4/1/24.
//

import UIKit

protocol GameProtocol: AnyObject {
    func gameDataFetched(_ data: [String])
}

class GameDataManager {
    
    weak var delegate: GameProtocol?
    
    func fetchData() {
        var wordStrings = [String]()
        
        //I think this is just shuffling the words in the word file, loading them into an array and picking the first one.
        if let fileURL = Bundle.main.url(forResource: K.wordsURL.fileName, withExtension: K.wordsURL.fileExtension) {
            if let wordContents = try? String(contentsOf: fileURL) {
                var lines = wordContents.components(separatedBy: "\n")
                
                lines.shuffle()
                wordStrings += lines
                
            }
        } else {
            fatalError("No words found!")
        }
        
        delegate?.gameDataFetched(wordStrings)
    }
    
}
