//
//  FAQsCell.swift
//  MVVM Template
//
//  Created by Sobhan Asim on 17/07/2022.
//

import UIKit

class FAQsCell: UITableViewCell {

    //MARK: - Identifiers
    
    static let identifier = "FAQsCell"
    
    //MARK: - Outlets
    
    @IBOutlet weak var questionLbl: UILabel!
    @IBOutlet weak var answerLbl: UILabel!
    @IBOutlet weak var faqOV: UIView!
    
    //MARK: - Life Cycle
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
//    func setCellData(_ faq: FaqData?){
//        questionLbl.setLocalized()
//        answerLbl.setLocalized()
//
//        questionLbl.text = faq?.question ?? "N/A"
//        answerLbl.text = faq?.answer ?? "N/A"
//
//    }
//    
}

//MARK: - Functions
extension FAQsCell {
    
}
