//
//  ChessBoardThemeCollectionViewCell.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-16.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

class ChessBoardThemeCollectionViewCell: UICollectionViewCell{
    //MARK: - Properties
    struct Default{
        static let color1:UIColor = UIColor.white
        static let color2:UIColor = UIColor.gray
    }
    
    func setSquareColors(with chessBoardTheme:ChessBoardTheme){
        color1 = chessBoardTheme.0
        color2 = chessBoardTheme.1
    }
    
    private var color1:UIColor = Default.color1{
        didSet{
            updateUI()
        }
    }
    
    private var color2:UIColor = Default.color2{
        didSet{
            updateUI()
        }
    }
    
    override func awakeFromNib() {
        updateUI()
    }
    
    private func updateUI(){
        topLeftSquare?.backgroundColor = topLeftColor
        bottomRightSquare?.backgroundColor = bottomRightColor
        bottomLeftSquare?.backgroundColor = bottomLeftColor
        topRightSquare?.backgroundColor = topRightColor
    }
    

    //MARK: - Computed Properties
    
    var topLeftColor: UIColor{return self.color1}
    var topRightColor:UIColor{return self.color2}
    var bottomLeftColor:UIColor{return self.color2}
    var bottomRightColor:UIColor{return self.color1}
    
    
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
    
    convenience init(frame: CGRect, color1:UIColor,color2:UIColor) {
        self.init(frame: frame)
        self.color1 = color1
        self.color2 = color2
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        self.color1 = Default.color1
        self.color2 = Default.color2
        super.init(coder: aDecoder)
    }
    
    
    
    
}
