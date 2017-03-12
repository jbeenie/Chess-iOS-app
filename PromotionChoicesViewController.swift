//
//  PromotionChoicesViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-09.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class PromotionChoicesViewController: UIViewController {
    //MARK: - Constants
    struct Constant{
        static let buttonConrnerRadius:CGFloat = 3.0
    }
    
    struct Default{
        static let pieceColor: ChessPieceView.ChessPieceColor = .Black
    }
    
    struct Ratios{
        static let buttonWidthToSpacing: CGFloat = 4.0
        static let ImageInsetToButtonWidth: CGFloat = 0.05
    }
    
    
    
    //MARK: - Stored Properties
    var colorOfPieces: ChessPieceView.ChessPieceColor? = nil
    var completionHandler: (closure:((ChessPieceType,Position)->Void),positionData: Position)? = nil
    
    //MARK: - Computed Properties
    
    var numButtons:Int{ return buttonStack.subviews.count}
    var numSpaces:Int{return numButtons - 1}
    var buttonImageInsets: UIEdgeInsets{
        let buttonWidth = knightUIButton.frame.width
        let imageInset:CGFloat = buttonWidth * Ratios.ImageInsetToButtonWidth
        return UIEdgeInsetsMake(imageInset,imageInset,imageInset,imageInset)
    }
    
    //MARK: Computed View Dimensions
    
    var buttonSpacing: CGFloat{
        return (buttonStack.frame.size.width)/((CGFloat(numButtons) * Ratios.buttonWidthToSpacing + CGFloat(numSpaces))) - 20.0
    }
    
    var stackHeight:CGFloat{
        return (buttonStack.frame.size.width - CGFloat(numSpaces)*buttonSpacing)/CGFloat(numButtons)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpView()
    }

    
    //MARK: Outlets
    
    //MARK: StackView
    @IBOutlet weak var buttonStack: UIStackView!
    
    //MARK: UIButtons
    @IBOutlet weak var knightUIButton: UIButton!
    @IBOutlet weak var bishopUIButton: UIButton!
    @IBOutlet weak var rookUIButton: UIButton!
    @IBOutlet weak var queenUIButton: UIButton!
    

    var buttons:[(ChessPieceView.ChessPieceIdentifier,UIButton?,Int)]{
        return [
            (ChessPieceView.ChessPieceIdentifier(color: colorOfPieces ?? Default.pieceColor, type: .Knight_R),knightUIButton,1),
            (ChessPieceView.ChessPieceIdentifier(color: colorOfPieces ?? Default.pieceColor, type: .Bishop),bishopUIButton,2),
            (ChessPieceView.ChessPieceIdentifier(color: colorOfPieces ?? Default.pieceColor, type: .Rook),rookUIButton,3),
            (ChessPieceView.ChessPieceIdentifier(color: colorOfPieces ?? Default.pieceColor, type: .Queen),queenUIButton,4)
        ]
    }
    
    var buttonTypes: [Int:ChessPieceType] {
        return [1:.Knight, 2:.Bishop, 3:.Rook, 4:.Queen]
    }
    
    //Set up Button Appearance
    private func setupButtons(){
        for (iconID,button,tag) in buttons{
            button?.layer.cornerRadius = Constant.buttonConrnerRadius
            if let buttonIcon = ChessPieceView.ChessPieceIcons[iconID]{
                button?.setImage(buttonIcon, for: .normal)
                button?.imageEdgeInsets = buttonImageInsets
                button?.sizeToFit()
                button?.imageView?.contentMode = UIViewContentMode.scaleAspectFit
                button?.tag = tag
            }
        }
    }
    
    private func setupButtonStack(){
        buttonStack.spacing = buttonSpacing
        buttonStack.frame.setHeight(to: stackHeight)
        buttonStack.setNeedsLayout()
    }
    
    private func setUpView(){
        setupButtons()
        setupButtonStack()
    }
    
    //MARK: Actions
    
    @IBAction func chosePieceToPromoteTo(_ sender: UIButton) {
        guard let chessPieceType = buttonTypes[sender.tag] else {return}
        self.presentingViewController?.dismiss(animated: true, completion:
            {self.completionHandler?.closure(chessPieceType,self.completionHandler!.positionData)})
    }
    
}
