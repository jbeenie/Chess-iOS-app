//
//  ChessBoardThemeCollectionViewController.swift
//  Chess
//
//  Created by Jeremie Benhamron on 2017-03-16.
//  Copyright © 2017 beenie.inc. All rights reserved.
//

import UIKit
import Themeable


class ChessBoardThemeCollectionViewController: ThemeableCollectionViewController,UICollectionViewDelegateFlowLayout{
    
    private let reuseIdentifier:String = "ChessBoardTheme"
    
    
    
    //MARK: -  MODEL
    
    //data structure storing chess board themes
    private let chessBoardthemes: [[ChessBoardTheme]] =
        [ChessBoardThemes.list]
    
    var selectedTheme:ChessBoardTheme! = nil
    var selectedThemeIndex:IndexPath!{
        return indexPath(of: selectedTheme)
    }
    
    
    
    // func used to determine the indexpath of the chessboard theme
    func indexPath(of chessBoardTheme:ChessBoardTheme)->IndexPath?{
        if let (section,item) = chessBoardthemes.index(of: chessBoardTheme){
            return IndexPath(item: item, section: section)
        }
        return nil
    }
    //meta data about chessboard themes data structure
    private var sections:Int{return chessBoardthemes.count}
    private func itemsPer(section:Int)->Int{return (section < sections) ? chessBoardthemes[section].count : 0}
    
    
    //MARK: - Constants
    struct Layout{
        static let minimumSpacingForSections:CGFloat = 1.0
        static let itemsPerRow:Int = 3
    }
    
    struct Selection{
        static let color:UIColor = UIColor.blue
        static let borderWidth:CGFloat = 2.0
    }
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView?.allowsSelection = true
        collectionView?.allowsMultipleSelection = false
    }
    
    


    // MARK: UICollectionViewDataSource
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        //return the number of sections
        return sections
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //return the number of items
        return itemsPer(section: section)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)
        // Configure the cell
        if let chessBoardThemeCell = cell as? ChessBoardThemeCollectionViewCell{
            chessBoardThemeCell.theme = chessBoardthemes[indexPath.section][indexPath.item]
            //select the the initially selected theme
            if indexPath == selectedThemeIndex{
                //inform the cell its selected
                chessBoardThemeCell.isSelected = (indexPath == selectedThemeIndex)
                //inform the collectionview which cell is selected
                collectionView.selectItem(at: indexPath, animated: true, scrollPosition: .top)
            }
            return chessBoardThemeCell
        }
        return cell
    }

    // MARK: UICollectionViewDelegate

   //Highlighting and Selecting Cells
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedTheme = chessBoardthemes[indexPath.section][indexPath.item]
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
    
    //MARK: - Update parent Settings VC with selected ChessBoard Theme
    private func updateSettings(){
        guard let settingsVC = self.previousViewController as? SettingsTableViewController else{return}
        settingsVC.globalSettings[ChessSettings.Key.chessBoardTheme] = selectedTheme
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        updateSettings()
    }
    
}
