# Add2App


# Getting Started

1) Have an Android Project
2) Create a new flutter module in your project.

`flutter create -t module flutter_module`

You are free to name and locate this in your repo as necessary

3) Add flutter to your `settings.gradle`

```
/// Add to settings.gradle
///
/// Update paths/names to correspond to your repo.
setBinding(new Binding([gradle: this]))
evaluate(new File(
        settingsDir.parentFile,
        'flutter_module/.android/include_flutter.groovy'
))
```

Note: the .android folder is not checked in. It's ephemeral to the flutter SDK

You need to call `flutter packages get` at least once to create this folder.

The `include_flutter.groovy` script will add plugins and a `:flutter` project to your gradle project.

* Note: At time of writing you may hit this
  https://stackoverflow.com/questions/68571973/pluginapplicationexception-failed-to-apply-plugin-class-flutterplugin?utm_source=feedburner&utm_medium=feed&utm_campaign=Feed%3A+stackoverflow%2FOxiZ+%28%5Bandroid+questions%5D%29



4) Add Flutter to your App

In your `app/build.gradle`

implementation project(':flutter')


## Interacting

A mirror API to the nav api will be exposed. Call these methods from native to start navigation
into flutter.

Method Call Binding options.