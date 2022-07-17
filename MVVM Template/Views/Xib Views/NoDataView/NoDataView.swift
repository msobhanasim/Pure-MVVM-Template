//
//  NoDataView.swift
//  MVVM Template
//
//  Created by Sobhan Asim on 17/07/2022.
//

import Foundation
import UIKit

enum NoDataViewType {
    case standardType
    case searchType
}


class NoDataView : UIView {

    static let identifier = "NoDataView"
    
    /// `No Data View Outlets`
    @IBOutlet weak var noDataView           : UIView!
    @IBOutlet weak var noDataViewImage      : UIImageView!
    @IBOutlet weak var noDataViewTitle      : UILabel!
    @IBOutlet weak var noDataViewDescription: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commitInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commitInit()
    }
    
    
    func commitInit () {
        let viewFromXib = Bundle.main.loadNibNamed(NoDataView.identifier, owner: self, options: nil)?.first as! UIView
        viewFromXib.frame = self.bounds
        addSubview(viewFromXib)
        
    }
    
    func setViewDetails(_ title : String , _ details : String = "", _ type: NoDataViewType = .standardType, _ backGroundColor: UIColor) {
        self.noDataViewTitle.text       = title
        self.noDataViewDescription.text = details
        self.noDataView.backgroundColor = backGroundColor
        
        if type == .standardType {
            noDataViewImage.image = UIImage(named: "no_data_ic")
        } else {
            noDataViewImage.image = UIImage(named: "no_search_results_ic")
        }
        
    }
    
}
