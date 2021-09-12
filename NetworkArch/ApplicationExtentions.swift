//
//  ApplicationExtentions.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 17/10/2020.
//

import Foundation
import UIKit

extension UIApplication {
    /// Root view conntroller for advertising
    /// We get top presented controller from active scene window
    var rootViewController: UIViewController? {
        let window = connectedScenes
            .filter { $0.activationState == .foregroundActive }
            .compactMap { $0 as? UIWindowScene }
            .first?
            .windows
            .filter { $0.isKeyWindow }
            .first

        var controller = window?.rootViewController
        while controller?.presentedViewController != nil {
            controller = controller?.presentedViewController
        }

        return controller
    }
}

extension UIDevice {
    var isPad: Bool { userInterfaceIdiom == .pad }
}
