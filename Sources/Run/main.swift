import App

do {
    try app(.detect()).run()
} catch {
    print(error)
}
