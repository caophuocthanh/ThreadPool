# ThreadPool

I have problem with Thread. It is not release after run excute my code. So, I have to find a solution. And then, I figure out a solution like this repo. I work well like what i want.

Thanks https://github.com/realm/realm-cocoa/issues/4030

```swift

ThreadPool(name: "ThreadPool").perform {
    // Your code
}

```
