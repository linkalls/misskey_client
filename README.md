## misskey client
A client for Misskey API　written in Dart.


## 使い方
.sample.envを.envにリネームして、MisskeyのインスタンスのURLとアクセストークンを入力してください。
そのあと、以下のコマンドを実行してください。
```shell
flutter pub get
```
そのあとに.envを読み込むために以下のコマンドを実行してください。
```shell
dart run enven
```
そのあと、以下のコマンドを実行してビルドしてください
```shell
flutter build apk
```




`<uses-permission>` タグは、`<manifest>` タグの直下に記述します。以下のように `<uses-permission android:name="android.permission.INTERNET"/>` を追加してください。

修正後の 

AndroidManifest.xml

 は以下のようになります。

```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <!-- インターネットアクセスの許可 -->
    <uses-permission android:name="android.permission.INTERNET"/>

    <application
        android:label="misskey"
        android:name="${applicationName}"
        android:icon="@mipmap/ic_launcher">
        <activity
            android:name=".MainActivity"
            android:exported="true"
            android:launchMode="singleTop"
            android:taskAffinity=""
            android:theme="@style/LaunchTheme"
            android:configChanges="orientation|keyboardHidden|keyboard|screenSize|smallestScreenSize|locale|layoutDirection|fontScale|screenLayout|density|uiMode"
            android:hardwareAccelerated="true"
            android:windowSoftInputMode="adjustResize">
            <!-- Specifies an Android theme to apply to this Activity as soon as
                 the Android process has started. This theme is visible to the user
                 while the Flutter UI initializes. After that, this theme continues
                 to determine the Window background behind the Flutter UI. -->
            <meta-data
              android:name="io.flutter.embedding.android.NormalTheme"
              android:resource="@style/NormalTheme"
              />
            <intent-filter>
                <action android:name="android.intent.action.MAIN"/>
                <category android:name="android.intent.category.LAUNCHER"/>
            </intent-filter>
        </activity>
        <!-- Don't delete the meta-data below.
             This is used by the Flutter tool to generate GeneratedPluginRegistrant.java -->
        <meta-data
            android:name="flutterEmbedding"
            android:value="2" />
    </application>
    <!-- Required to query activities that can process text, see:
         https://developer.android.com/training/package-visibility and
         https://developer.android.com/reference/android/content/Intent#ACTION_PROCESS_TEXT.

         In particular, this is used by the Flutter engine in io.flutter.plugin.text.ProcessTextPlugin. -->
    <queries>
        <intent>
            <action android:name="android.intent.action.PROCESS_TEXT"/>
            <data android:mimeType="text/plain"/>
        </intent>
        <!-- こっから追加 -->
        <intent>
            <action android:name="android.intent.action.VIEW" />
            <data android:scheme="https" />
        </intent>
        <!-- If your app makes calls -->
        <intent>
            <action android:name="android.intent.action.DIAL" />
            <data android:scheme="tel" />
        </intent>
        <!-- If your sends SMS messages -->
        <intent>
            <action android:name="android.intent.action.SENDTO" />
            <data android:scheme="smsto" />
        </intent>
        <!-- If your app sends emails -->
        <intent>
            <action android:name="android.intent.action.SEND" />
            <data android:mimeType="*/*" />
        </intent>
        <!-- ここまで -->
    </queries>
</manifest>
```

これで、アプリがインターネットアクセスの許可を要求するようになります。
