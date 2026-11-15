import SwiftUI

struct AlertPresenter: View {
    @ObservedObject var store: AlertStore

    var body: some View {
        Color.clear
            .frame(width: 0, height: 0)
            .alert(item: $store.alert) { alert in
                Alert(title: Text(alert.title), message: Text(alert.message), dismissButton: .default(Text("好")))
            }
    }
}
