//
//  FlagsWidget.swift
//  FlagsWidget
//
//  Created by Richard Robinson on 2021-05-31.
//

import WidgetKit
import SwiftUI

struct Provider: TimelineProvider {
  let provider = CountryProvider.shared

  func placeholder(in context: Context) -> SimpleEntry {
    let currentDate = Date()
    let country = self.provider.countryOfTheDay(for: currentDate)

    return SimpleEntry(date: currentDate, country: country)
  }

  func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> Void) {
    let currentDate = Date()
    let country = self.provider.countryOfTheDay(for: currentDate)

    let entry = SimpleEntry(date: currentDate, country: country)
    completion(entry)
  }

  func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> Void) {
    let currentDate = Date()
    let midnight = Calendar.current.startOfDay(for: currentDate)
    let nextMidnight = Calendar.current.date(byAdding: .day, value: 1, to: midnight)!

    let country = self.provider.countryOfTheDay(for: midnight)

    let entries = [
      SimpleEntry(date: nextMidnight, country: country)
    ]

    let timeline = Timeline(entries: entries, policy: .after(nextMidnight))
    completion(timeline)
  }
}

struct SimpleEntry: TimelineEntry {
  let date: Date
  let country: Country
}

struct FlagWidgetEntryView: View {
  let entry: Provider.Entry

  var body: some View {
    Image(self.entry.country.flagImageName)
      .resizable()
      .aspectRatio(contentMode: .fill)
      .widgetURL(self.widgetUrl)
  }

  var widgetUrl: URL? {
    var components = URLComponents()
    components.scheme = "com.richardrobinson.vexillum"
    components.host = "widget"
    components.path = "/\(self.entry.country.id)"

    return components.url
  }
}

@main
struct FlagWidget: Widget {
  let kind: String = "FlagWidget"

  var body: some WidgetConfiguration {
    StaticConfiguration(kind: kind, provider: Provider()) { entry in
      FlagWidgetEntryView(entry: entry)
    }
    .configurationDisplayName("Flag of the Day")
    .description("See a new featured flag every day.")
    .supportedFamilies([.systemSmall])
  }
}

struct FlagWidget_Previews: PreviewProvider {
  static let entry = SimpleEntry(date: Date(), country: CountryProvider.shared.countryOfTheDay(for: Date()))

  static var previews: some View {
    FlagWidgetEntryView(entry: entry)
      .previewContext(WidgetPreviewContext(family: .systemSmall))
  }
}
