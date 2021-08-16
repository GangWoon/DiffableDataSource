//
//  DetailMemberPreview.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/08/05.
//

import SwiftUI

struct DetailMemberPreview: View {
    var body: some View {
        WrappedViewController(DetailMemberViewController()) { viewController in
            viewController.updateSubject
                .send(DetailMemberViewController.ViewState(
                    profile: .profile,
                    name: "GangWoon",
                    team: "iOS",
                    bio: "Hello Swift."
                ))
        }
    }
}

struct DetailMemberPreview_Previews: PreviewProvider {
    static var previews: some View {
        DetailMemberPreview()
    }
}
