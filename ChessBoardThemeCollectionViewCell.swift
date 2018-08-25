//
//  ChessBoardThemeCollectionViewCell.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-16.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
import Themeable

@IBDesignable
class ChessBoardThemeCollectionViewCell: ThemeableCollectionViewCell{
    //MARK: - Default values
    struct Default{
        static let theme:ChessBoardTheme = ChessBoardThemes.GrayWhite
    }
    
    struct Selection{
        static var color = UIColor.blue.withAlphaComponent(0.75)
    }
    
     var selectionBackgroundView:UIView{
        let selectionBackgroundView = UIView()
        selectionBackgroundView.backgroundColor = Selection.color
        return selectionBackgroundView
    }
    
    

    
    //MARK: MODEL
    var theme:ChessBoardTheme = Default.theme{
        didSet{
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.selectedBackgroundView = selectionBackgroundView
    }
    
    //MARK: Updating View
    private func updateUI(){
        topLeftSquare?.backgroundColor = topLeftColor
        bottomRightSquare?.backgroundColor = bottomRightColor
        bottomLeftSquare?.backgroundColor = bottomLeftColor
        topRightSquare?.backgroundColor = topRightColor
    }

    
    

    //MARK: - Computed Properties
    var topLeftColor: UIColor{return self.theme.whiteSquareColor}
    var topRightColor:UIColor{return self.theme.blackSquareColor}
    var bottomLeftColor:UIColor{return self.theme.blackSquareColor}
    var bottomRightColor:UIColor{return self.theme.whiteSquareColor}
    
    var squares:[UIView]{
        return [topLeftSquare,bottomRightSquare,bottomLeftSquare,topRightSquare]
    }
    
    //MARK: - Outlets
    //Group 1
    @IBOutlet weak var topLeftSquare: UIView!
    @IBOutlet weak var bottomRightSquare: UIView!
    
    //Group 2
    @IBOutlet weak var bottomLeftSquare:UIView!
    @IBOutlet weak var topRightSquare:UIView!
    
    //MARK: - Cusotmizing Themeable
    
    override func apply(theme: AppTheme) {
        super.apply(theme: theme)
        ChessBoardThemeCollectionViewCell.Selection.color = theme.collectionViewCellSelectedBackgroundColor
    }
    
}
