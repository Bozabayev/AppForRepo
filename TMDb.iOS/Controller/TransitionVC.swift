//
//  TransitionVC.swift
//  TMDb.iOS
//
//  Created by Rauan on 11/22/18.
//  Copyright © 2018 Rauan. All rights reserved.
//

import UIKit

 var transitionNumber = 1

class TransitionVC: UIViewController {

    
   
    override func viewDidLoad() {
        super.viewDidLoad()

        let storyboard = UIStoryboard(name: "Main", bundle: nil )
        let accountVC = storyboard.instantiateViewController(withIdentifier: "AccountVC")
        let userVC = storyboard.instantiateViewController(withIdentifier: "UserVC")
        if transitionNumber == 1 {
        self.navigationController?.pushViewController(accountVC, animated: false)
        } else if transitionNumber == 2 {
            self.navigationController?.pushViewController(userVC, animated: false)
        }
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
