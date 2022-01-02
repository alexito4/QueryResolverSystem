import Foundation

final class AsyncFuture<T> {
    private let buffer = Buffer()

//    func onValue(_ f: @escaping (T) -> Void) {
//        Task {
//            await state.addCallbackIfNeeded(f)
//        }
//    }

    func getValue() async throws -> T {
        let result: Buffer.Termination = await withTaskCancellationHandler(operation: {
            await withCheckedContinuation { continuation in
                Task {
                    await buffer.addContinuationIfNeeded(continuation)
                }
            }
        }, onCancel: {
            Task {
                await buffer.cancel()
            }
        })
        try Task.checkCancellation()
        return result.value!
    }

    // should be in a separate class so is not public
    func send(_ v: T) {
        Task {
            await buffer.send(v)
        }
    }

    actor Buffer {
        enum State {
            case pending
            case fulfilled(T)
            case cancelled

            var isPending: Bool {
                if case .pending = self {
                    return true
                }
                return false
            }

            var isCancelled: Bool {
                if case .cancelled = self {
                    return true
                }
                return false
            }

            var value: T? {
                if case let .fulfilled(value) = self {
                    return value
                }
                return nil
            }
        }

        enum Termination {
            /// The stream was finished via the `finish` method
            case finished(T)

            /// The stream was cancelled
            case cancelled

            var value: T? {
                if case let .finished(value) = self {
                    return value
                }
                return nil
            }
        }

        private var continuations = [CheckedContinuation<Termination, Never>]()
        private var state: State = .pending

        func addContinuationIfNeeded(_ continuation: CheckedContinuation<Termination, Never>) {
            assert(!state.isCancelled)

            if let value = state.value {
                continuation.resume(returning: .finished(value))
                return
            }

            continuations.append(continuation)
        }

        func send(_ v: T) {
            guard !state.isCancelled else { return }
            assert(state.isPending, "AsyncFuture should only receive 1 value.")
            print("send", v)

            state = .fulfilled(v)
            continuations.forEach { $0.resume(returning: .finished(v)) }
            continuations.removeAll()
        }

        func cancel() {
            state = .cancelled
            continuations.forEach { $0.resume(returning: .cancelled) }
            continuations.removeAll()
        }
    }
}

extension AsyncFuture {
//    func map<R>(_ f: @escaping (T) -> R) -> AsyncFuture<R> {
//        let newFuture = AsyncFuture<R>()
//        onValue { t in
//            newFuture.send(f(t))
//        }
//        return newFuture
//    }
}

extension AsyncFuture {
    convenience init(_ build: @escaping () async -> T) {
        self.init()
        Task.detached {
            self.send(await build())
        }
    }
}

func makeAPICall() -> AsyncFuture<String> {
    let future = AsyncFuture<String> {
        await Task.sleep(1 * NSEC_PER_SEC) // make call...
        return "hello world"
    }
    return future
}

// @main
enum AsyncFutureTest {
    static func main() {
        print("AsyncFutureTest")

        let apiResponse = AsyncFuture<String>() // makeAPICall()
        Task.detached {
            await Task.sleep(2 * NSEC_PER_SEC)
            apiResponse.send("bye")
        }

//        apiResponse
//            .map(\.count)
//            .onValue {
//                print("onValue", $0)
//            }

        let t = Task.detached {
            let result = try await apiResponse.getValue()
            print("getValue", result)
        }
        Task.detached {
            await Task.sleep(1 * NSEC_PER_SEC)
            t.cancel()
            print("cancelled")
        }

        dispatchMain()
    }
}
