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

enum NumberOfEntriesForSize : Int{
    case small = 1
    case medium = 3
    case large = 5
}

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
        // use the max number of entries we can have
        let currentDate = Date()
        for hourOffset in 0 ..< NumberOfEntriesForSize.large.rawValue {
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
    let coordinator =  AppEnvironment.Preview
    let rowFormatter : RowFormattable.Type = RowFormatter.self
}

struct WeatherWidgetEntryView : View {
    var entry: Provider.Entry
    
    @Environment(\.widgetFamily) var family: WidgetFamily
    
    var body: some View {
        if let _periods = entry.coordinator.weather.fullForecast?.periods{
            let periodsToShow = getPeriods(forSizeClass: family,
                                           allPeriods: _periods)
            
            switch family {
            case .systemSmall:
                if let hiLowTemps = entry.coordinator.weather.getHiLow(forDate: entry.date){
                    SmallWidgetView(hiLowTemp: hiLowTemps)
                }else{
                    Text("shit broke")
                }
            case .systemMedium:
                MediumWidgetView(periods: periodsToShow)
            case .systemLarge:
                if let todayHiLow = entry.coordinator.weather.getHiLow(forDate: entry.date){
                    LargeWidgetView(hourlyPeriods: entry.coordinator.weather.getHourly(forDate: Date(), includingNext: 5),
                              todayHiLow: todayHiLow)
                }else{
                    Text("shit broke")
                }
                
            @unknown default:
                if let hiLowTemps = entry.coordinator.weather.getHiLow(forDate: entry.date){
                    SmallWidgetView(hiLowTemp: hiLowTemps)
                }else{
                    Text("shit broke")
                }
            }
        }
    }
    
    private func getPeriods(forSizeClass sizeClass : WidgetFamily, allPeriods periods : [Forecast.Period]) -> [Forecast.Period]{
        var returnPeriods = [Forecast.Period]()
        
        switch sizeClass {
        case .systemSmall:
            returnPeriods = Array(periods.prefix(upTo: NumberOfEntriesForSize.small.rawValue))
        case .systemMedium:
            returnPeriods = Array(periods.prefix(upTo: NumberOfEntriesForSize.medium.rawValue))
        case .systemLarge:
            returnPeriods = Array(periods.prefix(upTo: NumberOfEntriesForSize.large.rawValue))
        @unknown default:
            returnPeriods = Array(periods.prefix(upTo: NumberOfEntriesForSize.small.rawValue))
        }
        return returnPeriods
    }
}

@main
struct WeatherWidget: Widget {
    let kind: String = "WeatherWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind,
                            intent: ConfigurationIntent.self,
                            provider: Provider()) { entry in
            WeatherWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Weather Widget")
        .description("Hi .... Hello.")
    }
}

struct WeatherWidget_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            WeatherWidgetEntryView(entry: WeatherEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
            
            WeatherWidgetEntryView(entry: WeatherEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemMedium))
            
            WeatherWidgetEntryView(entry: WeatherEntry(date: Date(), configuration: ConfigurationIntent()))
                .previewContext(WidgetPreviewContext(family: .systemLarge))
        }
    }
}
