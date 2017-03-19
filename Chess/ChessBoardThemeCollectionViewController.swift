//
//  ChessBoardThemeCollectionViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-16.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

struct ChessBoardTheme{
    let whiteSquareColor:UIColor
    let blackSquareColor:UIColor
}


class ChessBoardThemeCollectionViewController: UICollectionViewController,UICollectionViewDelegateFlowLayout {
    private let reuseIdentifier:String = "ChessBoardTheme"

    struct ChessBoardThemes{
        static let GreenWhite = ChessBoardTheme(whiteSquareColor: UIColor.green, blackSquareColor: UIColor.white)
        static let GrayWhite = ChessBoardTheme(whiteSquareColor: UIColor.gray, blackSquareColor: UIColor.white)
        static let BrownYellow = ChessBoardTheme(whiteSquareColor: UIColor.brown, blackSquareColor: UIColor.yellow)
    }
    
    struct Layout{
        static let minimumSpacingForSections:CGFloat = 1.0
        static let itemsPerRow:Int = 3
    }
    
    struct Selection{
        static let color:UIColor = UIColor.blue
        static let borderWidth:CGFloat = 2.0
    }
    
    
    //MARK: -  MODEL
    let chessBoardThemes:[[ChessBoardTheme]] =
        [[ChessBoardThemes.GreenWhite,
         ChessBoardThemes.GrayWhite,
         ChessBoardThemes.BrownYellow]]
    
    var selectedTheme:ChessBoardTheme?=nil

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.allowsSelection = true
    }
    
    


    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //return the number of sections
        return chessBoardThemes.count
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return the number of items
        return chessBoardThemes[section].count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        // Configure the cell
        if let chessBoardThemeCell = cell as? ChessBoardThemeCollectionViewCell{
            chessBoardThemeCell.theme = chessBoardThemes[indexPath.section][indexPath.row]
            print("poo")
            return chessBoardThemeCell
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

   //Highlighting and Selecting Cells
    

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: indexPath){
            select(cell: cell)
        }
    }
    
    
    private func select(cell:UICollectionViewCell){ 
        selectedTheme = (cell as? ChessBoardThemeCollectionViewCell)?.theme
    }
    
    
    
    
    
    //MARK: Flow Layout delegate conformance 
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width / CGFloat(Layout.itemsPerRow)) - Layout.minimumSpacingForSections
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.minimumSpacingForSections
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Layout.minimumSpacingForSections
    }



}
