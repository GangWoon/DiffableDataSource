//
//  Helper.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/07/23.
//

import UIKit
import SwiftUI

extension String {
    static var name: Self {
        [
            "Sally", "Neil", "Gangwoon", "TTozzi", "Lin", "Olaf",
            "JK", "Yagom", "Hamil", "Dion", "Lena"
        ]
        .randomElement() ?? ""
    }
    static var bio: Self {
        [
            "Lorem ipsum dolor sit amet, consectetuer adipiscing elit.",
            "Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.",
            "Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem.",
            "Nulla consequat massa quis enim.",
            "Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo.",
            "Nullam dictum felis eu pede mollis pretium.",
            "Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi.",
            "Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus.",
            "Phasellus viverra nulla ut metus varius laoreet.",
            "Quisque rutrum. Aenean imperdiet. Etiam ultricies nisi vel augue.",
            "Curabitur ullamcorper ultricies nisi. Nam eget dui. Etiam rhoncus.",
            "Maecenas tempus, tellus eget condimentum rhoncus, sem quam semper libero, sit amet adipiscing sem neque sed ipsum.",
            "Nam quam nunc, blandit vel, luctus pulvinar, hendrerit id, lorem. Maecenas nec odio et ante tincidunt tempus.",
            "Donec vitae sapien ut libero venenatis faucibus. Nullam quis ante.",
            "Etiam sit amet orci eget eros faucibus tincidunt. Duis leo.",
            "Sed fringilla mauris sit amet nibh. Donec sodales sagittis magna. Sed consequat, leo eget bibendum sodales, augue velit cursus nunc"
        ]
        .randomElement() ?? ""
    }
    
    func image() -> UIImage? {
        let size = CGSize(width: 60, height: 60)
        UIGraphicsBeginImageContextWithOptions(size, false, .zero)
        UIColor.clear.set()
        let rect = CGRect(origin: .zero, size: size)
        UIRectFill(rect)
        (self as NSString).draw(
            in: rect,
            withAttributes: [.font: UIFont.systemFont(ofSize: 55)]
        )
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return image
    }
}
extension UIImage {
    static var profile: UIImage {
        let dummyEmoji = [
            "😀", "😃", "😄", "😁", "😆", "🤩", "🥳",
            "😱", "🤥", "🤔", "😷", "🤠", "🚌", "🐶",
            "🦁", "🐣", "🦭", "🐳", "🌽", "🍔", "🍺"
        ]
        .randomElement() ?? ""
        return dummyEmoji.image() ?? UIImage()
    }
}

struct WrappedViewController<Wrapped: UIViewController>: UIViewControllerRepresentable {
   
    private let viewController: Wrapped
    private var update: (Wrapped) -> Void
    
    init(_ viewController: Wrapped, update: @escaping (Wrapped) -> Void) {
        self.viewController = viewController
        self.update = update
    }
    
    func makeUIViewController(context: Context) -> Wrapped {
        viewController
    }
    
    func updateUIViewController(_ uiViewController: Wrapped, context: Context) {
        update(uiViewController)
    }
}

struct WrappedView<Wrapped: UIView>: UIViewRepresentable {
    
    private let view: Wrapped
    private let update: (Wrapped) -> Void
    
    init(_ view: Wrapped, update: @escaping (Wrapped) -> Void) {
        self.view = view
        self.update = update
    }
    
    func makeUIView(context: Context) -> Wrapped {
        view
    }
    
    func updateUIView(_ uiView: Wrapped, context: Context) {
        update(uiView)
    }
}
