//
//  AddMemberPreview.swift
//  DiffableDataSource
//
//  Created by Cloud on 2021/08/11.
//

import SwiftUI

struct AddMemberPreview: View {
    var body: some View {
        WrappedViewController(AddMemberViewController()) { viewController in

        }
    }
}

struct AddMemberPreview_Previews: PreviewProvider {
    static var previews: some View {
        AddMemberPreview()
            .previewLayout(.fixed(width: 400, height: 200))
    }
}
