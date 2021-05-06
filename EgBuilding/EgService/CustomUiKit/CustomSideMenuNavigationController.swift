//
//  CustomUINavigationController.swift
//  EgService
//
//  Created by (주)에너넷 on 2020/11/26.
//

// 참고 사이트 : https://gonslab.tistory.com/10

import UIKit
import SideMenu
import Foundation

// SideMenu 설정
class CustomSideMenuNavigationController: SideMenuNavigationController{
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 메뉴 띄울 때 View 옆으로 밀리지 않게
        self.presentationStyle = .menuSlideIn
        // 메뉴 왼쪽에서 나오게
        self.leftSide = true
        // 메뉴가 화면의 80%만큼 차지하게
        self.menuWidth = self.view.frame.width * 0.8
    }
    
    func onResult(_ Result: CaResult){
        
    }
}
