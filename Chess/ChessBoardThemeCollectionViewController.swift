//
//  ChessBoardThemeCollectionViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-16.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit

typealias ChessBoardTheme = (UIColor,UIColor)


class ChessBoardThemeCollectionViewController: UICollectionViewController {
    private let reuseIdentifier:String = "ChessBoardTheme"

    struct ChessBoardThemes{
        static let GreenWhite = (UIColor.green, UIColor.white)
        static let GrayWhite = (UIColor.gray, UIColor.white)
        static let BrownYellow = (UIColor.brown, UIColor.yellow)
    }
    
    
    //MARK: -  MODEL
    let chessBoardThemes:[[ChessBoardTheme]] =
        [[ChessBoardThemes.GreenWhite,
         ChessBoardThemes.GrayWhite,
         ChessBoardThemes.BrownYellow]]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Register cell classes
        self.collectionView!.register(ChessBoardThemeCollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
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
            chessBoardThemeCell.setSquareColors(with: chessBoardThemes[indexPath.section][indexPath.row])
            print("poo")
            return chessBoardThemeCell
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

   
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }


    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }


    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
