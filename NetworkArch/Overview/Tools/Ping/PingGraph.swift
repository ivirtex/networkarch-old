//
//  PingGraph.swift
//  NetworkArch
//
//  Created by Hubert Jóźwiak on 10/10/2020.
//
//
import SwiftUI
import SwiftUICharts

struct PingGraph: View {
    @State var pingData: [Double]
    @State var addr: String
    let myCustomStyle = Styles.barChartStyleNeonBlueLight
    
    var body: some View {
        VStack {
            LineView(data: pingData, title: addr, legend: "ms", style: myCustomStyle)
                .padding(.horizontal)
                .navigationBarTitle("Latency graph")
            Spacer()
        }
        .onAppear {
            myCustomStyle.darkModeStyle = Styles.barChartStyleNeonBlueDark
        }
    }
}

struct PingGraph_Previews: PreviewProvider {
    static var previews: some View {
        PingGraph(pingData: [1.0, 3.0], addr: "abc")
    }
}
