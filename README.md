# ✨ zig-libraries

<p align="center">
Zig 언어를 위한 유틸리티, 자료구조, I/O 등을 포함하는 경량 라이브러리 모음입니다.
</p>

## 🚀 Getting Started

### 📦 Installation

이 라이브러리를 **Zig 패키지 매니저**를 사용하여 프로젝트에 추가합니다.

#### 1. `build.zig.zon` 에 의존성 추가

```bash
zig fetch --save git+https://github.com/TinyProbe/zig-libraries
```

#### 2. `build.zig` 설정

```zig
const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    // ... 표준 설정 생략 ...

    const exe = b.addExecutable(.{
        .name = "your_project",
        .root_source_file = .{ .path = "src/main.zig" },
        .target = target,
        .optimize = optimize,
    });

    // 👇 zig-libraries 의존성 추가
    const zl = b.dependency("zig_libraries", .{});
    exe.root_module.addImport("zig_libraries", zl.module("zig_libraries"));

    // ... 표준 설정 생략 ...
}
```

### 🔨 build and run

```bash
zig build
./zig-out/bin/your_project
```

## Example Usage

`src/main.zig`:

```zig
const std = @import("std");
const zl = @import("zig_libraries"); // 라이브러리 모듈 임포트

var gpa = std.heap.GeneralPurposeAllocator(.{}) {};
const alloc = gpa.allocator(); // 메모리 할당자 준비

pub fn main() !void {
    // ⚠️ 메모리 누수 방지용 defer
    defer if (gpa.deinit() == .leak) std.debug.print("Memory leak detected!\n", .{});
    defer zl.io.cout.flush() catch unreachable;

    // 1. 📝 zl.str.Str: 동적 문자열
    var s = zl.str.Str.init(alloc); 
    defer s.deinit(); // 사용 후 메모리 해제

    try s.appendSlice("hello world!");
    zl.io.print("String Output: {s}\n", .{ s.items });

    // 2. 🔢 zl.vec.Vec: 동적 배열 (Vector)
    var v = zl.vec.Vec(usize).init(alloc); 
    defer v.deinit(); 

    // 3. 🔁 zl.rng.Rng: 인덱스 순회 반복자 (Range Iterator)
    // 0부터 99까지 (100 미만) 순회
    var rng = zl.rng.Rng(usize).init(0, 100); 
    while (rng.next()) |i| {
        // 반복자를 통해 생성된 값을 Vec에 추가
        try v.push(i);
    }

    // 4. zl.io.print: 개선된 콘솔 출력
    zl.io.print("Element at index 10: {d}\n", .{ v.items[10] });
}
```

## 🛠️ Core Modules

| 모듈 | 설명 | 포함된 주요 기능 |
| :--- | :--- | :--- |
| **`zl.str`** | 동적 크기의 문자열(`Str`) 및 문자열 조작 유틸리티 | `Str.appendSlice`, `Str.deinit` |
| **`zl.vec`** | 제네릭 동적 배열 (`Vec(T)`) | `Vec.push`, `Vec.pop`, `Vec.items` |
| **`zl.rng`** | 지정된 범위의 값을 순회하는 반복자 (`Rng(T)`) | `Rng.init`, `Rng.next` |
| **`zl.io`** | 표준 입출력 헬퍼 (포맷팅 및 버퍼링) | `io.print`, `io.cout.flush` |

## 🤝 Contributing

버그 리포트, 기능 제안, 또는 코드 개선을 위한 Pull Request는 언제나 환영합니다!

## 📄 License

이 프로젝트는 MIT 라이선스를 따릅니다.
