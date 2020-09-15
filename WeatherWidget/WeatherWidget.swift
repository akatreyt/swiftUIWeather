//
//  WeatherWidget.swift
//  WeatherWidget
//
//  Created by Trey Tartt on 9/15/20.
//

import WidgetKit
import SwiftUI
import Intents
import NationalWeatherService
import CoreLocation

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> WeatherEntry {
        WeatherEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (WeatherEntry) -> ()) {
        let entry = WeatherEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [WeatherEntry] = []
        
        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
        let currentDate = Date()
        for hourOffset in 0 ..< 5 {
            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
            let entry = WeatherEntry(date: entryDate, configuration: configuration)
            entries.append(entry)
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct WeatherEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
}

struct WeatherWidgetEntryView : View {
    var entry: Provider.Entry
    let forecast = MockNetwork().fetchSampleForecast()
    let rowFormatter : RowFormattable.Type = RowFormatter.self
    
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        let periodsToShow = getPeriods(forSizeClass: family,
                                       allPeriods: forecast.periods)
        
        if periodsToShow.count > 0{
            HStack{
                ForEach(periodsToShow, id: \.id){ period in
                    VStack{
                        Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Fahrenheit))
                            .font(.body)
                            .foregroundColor(Color("TextColor"))
                        Image(systemName: "cloud")
                            .foregroundColor(Color("TextColor"))
                        Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Celcius))
                            .font(.body)
                            .foregroundColor(Color("TextColor"))
                    }
                }
            }
        }
    }
    
    private func getPeriods(forSizeClass sizeClass : WidgetFamily, allPeriods periods : [Forecast.Period]) -> [Forecast.Period]{
        var returnPeriods = [Forecast.Period]()
        
        switch sizeClass {
        case .systemSmall:
            returnPeriods = Array(periods.prefix(upTo: 2))
        case .systemMedium:
            returnPeriods = Array(periods.prefix(upTo: 5))
        case .systemLarge:
            returnPeriods = Array(periods.prefix(upTo: 8))
        @unknown default:
            returnPeriods = Array(periods.prefix(upTo: 2))
        }
        return returnPeriods
    }
}

@main
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("Hi .... Hello.")
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        WeatherWidgetEntryView(entry: WeatherEntry(date: Date(), configuration: ConfigurationIntent()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
