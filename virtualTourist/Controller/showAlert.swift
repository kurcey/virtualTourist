//
//  showAlert.swift
//  virtualTourist
//
//  Created by user152630 on 6/22/19.
//  Copyright © 2019 user152630. All rights reserved.
//

import Foundation
import UIKit

class ShowAlert {
        var alertController: UIAlertController?

    func showAlertMsg(presentView: UIViewController, title: String, message: String) {
        let alertController: UIAlertController?
        guard (self.alertController == nil) else {
            return
        }
        
        alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
            self.alertController=nil;
        }
        alertController!.addAction(cancelAction)
        presentView.present(alertController!, animated: true, completion: nil)
    }
}
