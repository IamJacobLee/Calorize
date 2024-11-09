import Foundation
import SwiftUI
import Charts
import Observation
struct HistoryView: View {
    var body: some View{
        NavigationStack {
            List {
                ChartView(dataCollection: ViewModel())
            }
            .navigationTitle("History")
        }
                .font(.title)
                .bold()
    }
}


#Preview {
    HistoryView()
}
