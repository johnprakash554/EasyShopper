//
//  ProductCartCell.swift
//  TaskPoc
//
//  Created by Prakash's Mac on 09/11/24.
//

import UIKit

class ProductCartCell: UITableViewCell {
    @IBOutlet weak var cartImage: UIImageView!
    @IBOutlet weak var cartSelectBtn: UIButton!
    @IBOutlet weak var descLbl: UILabel!
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var cartView: UIView!
    @IBOutlet weak var checkmarkSelectedBtn: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cartView.applyCardStyle(cornerRadius: 5.0, shadowColor: .gray, shadowOpacity: 0.5, shadowOffset: CGSize(width: 0, height: 3), shadowRadius: 10.0)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func cartValueSelected(_ sender: UIButton) {
        cartSelectBtn.isSelected.toggle()
        
        cartSelectBtn.setImage(UIImage(named: "check-mark (1)"), for: .normal)
    }
}
