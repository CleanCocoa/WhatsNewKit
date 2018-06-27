//  Copyright © 2018 Christian Tietze. All rights reserved. Distributed under the MIT License.

extension Collection {
    internal subscript (safe index: Self.Index) -> Self.Iterator.Element? {
        return index < endIndex ? self[index] : nil
    }
}
