# iOS-Feature_Demos
Demonstrate iOS dev features in playground environment




### usingKeyedDecodingContainers
Utilizes initializer to create keyed decoding container and customize data format

-**formattedDateCodable**: utilizes `DateFormatter` for `Person`'s `birthday` element

-**formattedMeasurementCodable**: utilizes `MeasurementFormatter` for `Weather`'s `wind` and `temperature` elements, as well as `init(from decoder: Decoder)` to customize measurement format

-**formattedNumberCodable**: utilizes `NumberFormatter` to customize `Product`'s `price` element to conform to USD format. Defines `encode(to encoder: Encoder)` to conform to `Encodable`.
