//
//  ContentView.swift
//  BlockBreakerGame
//
//  Created by Cody Morley on 1/26/22.
//

import SwiftUI
import SpriteKit

struct ContentView: View {
    @AppStorage("bestScore") var bestScore = 0
    @StateObject private var gameScene = GameScene()
    
    var body: some View {
        ZStack {
            SpriteView(scene: gameScene)
            
            VStack(alignment: .leading) {
                Text("Level: \(gameScene.level)")
                    .font(.system(size: 12,
                                  weight: .heavy,
                                  design: .rounded))
                    .foregroundColor(.white)
                    .padding(.leading)
                    .padding(.top, 42)
                
                Text("Score: \(gameScene.score)")
                    .font(.system(size: 24,
                                  weight: .heavy,
                                  design: .rounded))
                    .foregroundColor(.white)
                    .padding(.leading)
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            if gameScene.isGameOver {
                VStack {
                    Text("GAME OVER")
                        .font(.system(size: 42,
                                      weight: .heavy,
                                      design: .rounded))
                        .foregroundColor(.white)
                        .padding(.leading)
                    
                    if gameScene.score > bestScore {
                        Text("New High Score: \(gameScene.score)")
                            .font(.system(size: 42,
                                          weight: .heavy,
                                          design: .rounded))
                            .foregroundColor(.white)
                            .padding(.leading)
                    }
                }
                
                Text("Play Again?")
                    .font(.system(size: 24,
                                  weight: .heavy,
                                  design: .rounded))
                    .foregroundColor(.white)
                    .padding(.leading)
                    .padding()
                    .onTapGesture {
                        if gameScene.score > bestScore {
                            bestScore = gameScene.score
                        }
                        gameScene.isGameOver.toggle()
                        gameScene.startNewGame()
                    }
            }
        }
        .ignoresSafeArea()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
