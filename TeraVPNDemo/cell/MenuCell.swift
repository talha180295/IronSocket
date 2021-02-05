//
//  MenuCell.swift
//  TeraVPNDemo
//
//  Created by Talha Ahmed on 17/09/2020.
//  Copyright © 2020 abc. All rights reserved.
//

import UIKit

class MenuCell: UITableViewCell {

    @IBOutlet weak var flag:UIImageView!
    @IBOutlet weak var countryName:UILabel!
    @IBOutlet weak var cityName:UILabel!
    @IBOutlet weak var time:UILabel!
    @IBOutlet weak var star:UIButton!
    
    var index:Int!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func didTapFav(_ sender:UIButton){
        
        var favList = UserDefaults.standard.value(forKey: User_Defaults.favServers) as? [String]
        if self.star.isSelected{
            self.star.isSelected = false
            if favList?.contains(countryName.text ?? "") == true{
                favList = favList?.filter { $0 != countryName.text }
                UserDefaults.standard.setValue(favList, forKey: User_Defaults.favServers)
            }
        }
        else{
            self.star.isSelected = true

            var newFavList = favList ?? []
            newFavList.append(countryName.text ?? "")
            UserDefaults.standard.setValue(newFavList, forKey: User_Defaults.favServers)
        }
    }
    
}
