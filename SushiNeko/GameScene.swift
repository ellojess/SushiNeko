//
//  GameScene.swift
//  SushiNeko
//
//  Created by Bo on 11/4/19.
//  Copyright © 2019 Jessica Trinh. All rights reserved.
//

import SpriteKit

/* Tracking enum for use with character and sushi side */
enum Side {
    case left, right, none
}

class GameScene: SKScene {
    /* Game objects */
    var sushiBasePiece: SushiPiece!
    /* Cat Character */
    var character: Character!
    /* Sushi tower array */
    var sushiTower: [SushiPiece] = []
    
    override func didMove(to view: SKView) {
        super.didMove(to: view)
        
    /* Connect game objects */
    sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
        
    /* Setup chopstick connections */
    sushiBasePiece.connectChopsticks()
        
    /* Connect game objects */
    sushiBasePiece = childNode(withName: "sushiBasePiece") as! SushiPiece
    character = childNode(withName: "character") as! Character
        
    /* Manually stack the start of the tower */
    addTowerPiece(side: .none)
    addTowerPiece(side: .right)
        
    /* Randomize tower to just outside of the screen */
    addRandomPieces(total: 10)
    }
    
    func addTowerPiece(side: Side) {
       /* Add a new sushi piece to the sushi tower */

       /* Copy original sushi piece */
       let newPiece = sushiBasePiece.copy() as! SushiPiece
       newPiece.connectChopsticks()

       /* Access last piece properties */
       let lastPiece = sushiTower.last

       /* Add on top of last piece, default on first piece */
       let lastPosition = lastPiece?.position ?? sushiBasePiece.position
       newPiece.position.x = lastPosition.x
       newPiece.position.y = lastPosition.y + 55

       /* Increment Z to ensure it's on top of the last piece, default on first piece*/
       let lastZPosition = lastPiece?.zPosition ?? sushiBasePiece.zPosition
       newPiece.zPosition = lastZPosition + 1

       /* Set side */
       newPiece.side = side

       /* Add sushi to scene */
       addChild(newPiece)

       /* Add sushi piece to the sushi tower */
       sushiTower.append(newPiece)
    }
    
    func addRandomPieces(total: Int) {
      /* Add random sushi pieces to the sushi tower */

      for _ in 1...total {

          /* Need to access last piece properties */
          let lastPiece = sushiTower.last!

          /* Need to ensure we don't create impossible sushi structures */
          if lastPiece.side != .none {
             addTowerPiece(side: .none)
          } else {

             /* Random Number Generator */
             let rand = arc4random_uniform(100)

             if rand < 45 {
                /* 45% Chance of a left piece */
                addTowerPiece(side: .left)
             } else if rand < 90 {
                /* 45% Chance of a right piece */
                addTowerPiece(side: .right)
             } else {
                /* 10% Chance of an empty piece */
                addTowerPiece(side: .none)
             }
          }
      }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        /* Called when a touch begins */
        /* We only need a single touch here */
        let touch = touches.first!
        /* Get touch position in scene */
        let location = touch.location(in: self)
        /* Was touch on left/right hand side of screen? */
        if location.x > size.width / 2 {
            character.side = .right
        } else {
            character.side = .left
        }
        /* Grab sushi piece on top of the base sushi piece, it will always be 'first' */
        if let firstPiece = sushiTower.first as SushiPiece? {
            /* Remove from sushi tower array */
            sushiTower.removeFirst()
            firstPiece.removeFromParent()
            /* Add a new sushi piece to the top of the sushi tower */
            addRandomPieces(total: 1)
        }
    }
    
    func moveTowerDown() {
        var n: CGFloat = 0; for piece in sushiTower {
            let y = (n * 55) + 215; piece.position.y -= (piece.position.y - y) * 0.5; n += 1
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveTowerDown()
    }
    
}


