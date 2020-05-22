# subtitle

字幕文件格式转换 | Parsing and conversion between different subtitle formats

## 使用方法 | Usage

```sh
swift run convert input.ext output.ext
```

where `ext` is one of `bcc`, `srt`, `vtt`

目前支持 `bcc`, `srt`, `vtt` 字幕文件格式之间的转换。

## 资源库 | SwiftPM Integration

```swift
.package(url: "https://github.com/Apollonyan/subtitle.git", branch: "master"),
```
