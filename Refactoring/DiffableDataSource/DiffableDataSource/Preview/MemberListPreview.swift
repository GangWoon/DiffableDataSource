//
//  MemberListPreview.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/07/23.
//

import SwiftUI

struct MemberListPreview: View {
    var body: some View {
        NavigationView(
            content: {
                WrappedViewController(MemberListViewController()) { viewController in
                    viewController.update(with: MemberListViewController.ViewState(members: [.dummy,.dummy,.dummy]))
                }
            }
        )
    }
}

struct MemerRowPreView: View {
    var body: some View {
        WrappedView(MemberListViewController.MemeberRow()) { view in
            view.update(with: .dummy)
        }
    }
}



struct MemberListPreview_Previews: PreviewProvider {
    static var previews: some View {
        MemberListPreview()
        MemerRowPreView()
            .previewLayout(.fixed(width: 414, height: 100))
    }
}

