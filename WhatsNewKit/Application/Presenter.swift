//  Copyright © 2020 Christian Tietze. All rights reserved. Distributed under the MIT License.

class Presenter<View>: StoreSubscriber {
    let view: View

    init(store: Store, view: View) {
        self.view = view
        super.init(store: store)
    }
}
