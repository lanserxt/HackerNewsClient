

# HackerNewsClient
Coding practice project. Hacker News reader written in SwiftUI and using Combine.

## Description

Using https://github.com/HackerNews/API load Latest, Top & Best news item. On top should be picker with news types and on list item tap you should show news details.

* Language: Swift 5.2
* Min iOS version: 13.0
* Tool: Xcode 11.5 (11E608c)

Frameworks:
- SwiftUI
- Combine

### UI
![Alt text](/screens/Main.png "Main View") ![Alt text](/screens/Loader.png "Loading View") ![Alt text](/screens/Detail.png "Detail View")
### Challenges

1) And the most obvious, it's the SwiftUI ) It's my second challenge project which I decided to complete using latest Apple UI framework. To make it more complicated, Combine framework used to React the whole developemnt )

2) API returning list of IDs on top layer and is limiting amount of request by ID so we can't run 20 async calls to get them and combine. Used dependency calls. Check the link below.

```swift
private func itemsPublisher(for itemIDs: [Int]) -> AnyPublisher<NewsItem, Error> {
        Publishers.Sequence(sequence: itemIDs.map { self.details(for: $0) })
            .flatMap(maxPublishers: .max(1)) { $0 }
            .eraseToAnyPublisher()
    }
```

3) API to get item by ID is returning (null) for some items. Had to use .map instead of .decode for decoding to cintinue .sink.
```swift
URLSession.shared.dataTaskPublisher(for: url)
            .mapError { $0 as Error }
            .compactMap { $0.data }
            .compactMap { try? JSONDecoder().decode(NewsItem.self, from: $0) }
            .eraseToAnyPublisher()
```
4) Loader with animation and amount of loaded items indicator

5) Localization

### Helpfull links:

[Swift forum](https://forums.swift.org/t/combine-decode-parse-valid-values-and-continue/30907) with discusssion of Combine error handling and flow
[URLSession and the Combine framework](https://theswiftdev.com/urlsession-and-the-combine-framework/)

### Known issues

 - List scroll continues on fast swipe and (Loading...) appear

License
----

MIT
