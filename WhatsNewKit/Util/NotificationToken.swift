//  Copyright © 2018 Ole Begemann.
//  <https://oleb.net/blog/2018/01/notificationcenter-removeobserver/>

/// Wraps the observer token received from
/// `NotificationCenter.addObserver(forName:object:queue:using:)`
/// and unregisters it in deinit.
final class NotificationToken: NSObject {
    let notificationCenter: NotificationCenter
    let token: Any

    init(notificationCenter: NotificationCenter = .default, token: Any) {
        self.notificationCenter = notificationCenter
        self.token = token
    }

    deinit {
        notificationCenter.removeObserver(token)
    }
}

extension NotificationCenter {
    /// Convenience wrapper for addObserver(forName:object:queue:using:)
    /// that returns our custom NotificationToken.
    func observe(name: NSNotification.Name?,
                 object obj: Any? = nil,
                 queue: OperationQueue? = nil,
                 using block: @escaping (Notification) -> ())
        -> NotificationToken
    {
        let token = addObserver(forName: name, object: obj, queue: queue, using: block)
        return NotificationToken(notificationCenter: self, token: token)
    }
}
