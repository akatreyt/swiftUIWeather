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
    let coordinator =  Coordinator<Network, PlistStorage, LocationManager>()
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
                SmallView(periods: periodsToShow)
            case .systemMedium:
                MediumView(periods: periodsToShow)
            case .systemLarge:
                LargeView(currentPeriod: entry.coordinator.weather.get(forDate: Date())!,
                          hourlyPeriods: entry.coordinator.weather.getHourly(forDate: Date(), includingNext: 5))
            @unknown default:
                SmallView(periods: periodsToShow)
            }
        }
    }
    
    private func getPeriods(forSizeClass sizeClass : WidgetFamily, allPeriods periods : [Forecast.Period]) -> [Forecast.Period]{
        var returnPeriods = [Forecast.Period]()
        
        switch sizeClass {
        case .systemSmall:
            returnPeriods = Array(periods.prefix(upTo: 1))
        case .systemMedium:
            returnPeriods = Array(periods.prefix(upTo: 3))
        case .systemLarge:
            returnPeriods = Array(periods.prefix(upTo: 6))
        @unknown default:
            returnPeriods = Array(periods.prefix(upTo: 2))
        }
        return returnPeriods
    }
}

struct SmallView : View {
    let periods : [Forecast.Period]
    let rowFormatter : RowFormattable.Type = RowFormatter.self
    
    var body: some View {
        HStack(alignment:.center){
            ForEach(periods, id: \.id){ period in
                VStack{
                    Text(period.name ?? "")
                        .font(.body)
                        .foregroundColor(Color("TextColor"))
                        .padding()
                    Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Fahrenheit))
                        .font(.body)
                        .foregroundColor(Color("TextColor"))
                    Image(uiImage: period.weatherIcon())
                        .foregroundColor(Color("TextColor"))
                    Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Celcius))
                        .font(.body)
                        .foregroundColor(Color("TextColor"))
                }
            }
        }
    }
}

struct MediumView : View {
    let periods : [Forecast.Period]
    let rowFormatter : RowFormattable.Type = RowFormatter.self
    var dateIntervalFormatter = DateIntervalFormatter(){
        didSet{
            dateIntervalFormatter.dateStyle = .short
            dateIntervalFormatter.timeStyle = .medium
        }
    }
    
    var body: some View {
        HStack{
            ForEach(periods, id: \.id){ period in
                VStack{
                    Text(period.name ?? "")
                        .font(.body)
                        .foregroundColor(Color("TextColor"))
                        .multilineTextAlignment(.center)
                    Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Fahrenheit))
                        .font(.body)
                        .foregroundColor(Color("TextColor"))
                    Image(uiImage: period.weatherIcon())
                        .foregroundColor(Color("TextColor"))
                    Text(rowFormatter.degreeToString(fromPeriod: period, forTemp: .Celcius))
                        .font(.body)
                        .foregroundColor(Color("TextColor"))
                    Text(period.shortForecast)
                        .font(.body)
                        .foregroundColor(Color("TextColor"))
                }
                Spacer()
            }
        }
        .padding()
    }
}

struct LargeView : View {
    let currentPeriod : Forecast.Period
    let hourlyPeriods : [Forecast.Period]
    
    let rowFormatter : RowFormattable.Type = RowFormatter.self
    
    var body: some View {
        HeaderView(period: currentPeriod, hourlyPeriods: hourlyPeriods)
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
